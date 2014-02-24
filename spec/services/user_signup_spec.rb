require 'spec_helper'

describe UserSignup do 
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg")}

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq("abcdefg")
      end

      it "makes the user follow the inviter" do
        ian = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: ian, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'joe doe')).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: 'bob@example.com').first
        expect(bob.follows?(ian)).to be_true 
      end

      it "makes the inviter follow the user" do
        ian = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: ian, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'joe doe')).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: 'bob@example.com').first
        expect(ian.follows?(bob)).to be_true 
      end

      it "expires the invitation upon acceptance" do
        ian = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: ian, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'joe doe')).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: 'bob@example.com').first
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: "password", full_name: "Joe blow")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe blow")
      end
    end

    context "valid personal info and declined card" do
      it "doesn't create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('1231241',nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid input" do
      it "doesn't create the user" do
        UserSignup.new(User.new(email: "ian.knauer@gmail.com")).sign_up('1231241',nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(User.new(email: "ian.knauer@gmail.com")).sign_up('1231241',nil)
      end
      it "doesn't send out email with invalid inputs" do
        UserSignup.new(User.new(email: "ian.knauer@gmail.com")).sign_up('1231241',nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end