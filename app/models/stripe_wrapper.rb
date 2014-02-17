module StripeWrapper
  class Charge
    def self.create(options={})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: 'cad',
        card: options[:card],
        description: options[:description]
      )
    end
  end
end