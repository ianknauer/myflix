require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2016,
            :cvc => "314"
          },
        ).id
        
        response = StripeWrapper::Charge.create(
          amount: 99,
          card: token,
          description: "A valid charge"
        )
        
        expect(response.amount).to eq(99)
        expect(response.currency).to eq('cad')
        
      end
    end
  end
end