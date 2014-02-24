require 'spec_helper'

describe "created payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_103YbP2E3uvvWEu3ve7Flrn6",
      "created" => 1393269324,
      "livemode"=> false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_103YbP2E3uvvWEu3Tlnr85mS",
          "object" => "charge",
          "created" => 1393269324,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "card" => {
            "id" => "card_103YbP2E3uvvWEu3OwB0c2W1",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 2,
            "exp_year" => 2016,
            "fingerprint" => "D11oQSDGNnZjNrgd",
            "customer" => "cus_3YbPOb7BQwWIwx",
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
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_103YbP2E3uvvWEu3evzY08mc",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_3YbPOb7BQwWIwx",
          "invoice" => "in_103YbP2E3uvvWEu3yjXIKtuS",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3YbPl8KQqS3fAo"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the correct user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3YbPOb7BQwWIwx")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the correct amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3YbPOb7BQwWIwx")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3YbPOb7BQwWIwx")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103YbP2E3uvvWEu3Tlnr85mS") 
  end
end