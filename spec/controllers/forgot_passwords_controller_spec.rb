require 'spec_helper'

describe ForgotPasswordsController do
  after { ActionMailer::Base.deliveries.clear }
  
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank.")
      end
    end
    context "with existing email" do
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com" 
        expect(response).to redirect_to forgot_password_confirmation_path       
      end
      it "sends out an email to the email address" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end
    end
    context "with non-existant email" do
      it "redirects to the fogot password page" do
        post :create, email: 'foo@example.bar'
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: 'foo@example.bar'
        expect(flash[:error]).to eq("Unable to send email, please try again")
      end
    end
  end
end