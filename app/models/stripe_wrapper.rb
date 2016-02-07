module StripeWrapper #wrapper for the STRIPE ruby api. Used within user_signup.rb
  class Charge
    attr_reader :error_message, :response

    def initialize(options={}) #create charge object with response and error messages
      @response = options[:response]
      @error_message = options[:error_message]
    end
    def self.create(options={})
      begin
        response = Stripe::Charge.create( #creating a charge through the stripe API
          amount: options[:amount],
          currency: 'cad',
          card: options[:card],
          description: options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e #rescues any errors that come up
        new(error_message: e.message) #adds errors to @error_message
      end
    end
    def successful? #response won't be present if stripe rescues from error
      response.present?
    end
  end

  class Customer #creates new customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create( #creates new customer, adds them to "base plan" as defined in stripe.
          card: options[:card],
          email: options[:user].email,
          plan: "base"
        )
        new(response: response)
      rescue Stripe::CardError => e #rescue from user creation
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end
  end
end
