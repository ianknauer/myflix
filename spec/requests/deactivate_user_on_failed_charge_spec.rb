require 'spec_helper'

describe "deactivate User on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_103YeB2E3uvvWEu39IGKNn55",
      "created" => 1393279669,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_103YeB2E3uvvWEu3NXzjzeTo",
          "object" => "charge",
          "created" => 1393279669,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "card" => {
            "id" => "card_103YeA2E3uvvWEu35nNBCSG9",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 2,
            "exp_year" => 2017,
            "fingerprint" => "kCj5em7AddYsdzch",
            "customer" => "cus_3YcOOP2JnoVKIL",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_3YcOOP2JnoVKIL",
          "invoice" => nil,
          "description" => "Testing out failure",
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3YeBGG9JlppTHg"
    }
  end

  it "deactivates a user with the web hook data from stripe for a failed charge", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3YcOOP2JnoVKIL")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end 
end