class UserSignup #created a user_signup service because there shouldn't be this much logic running in the controller
  attr_reader :error_message #allows error_message to be used in controller

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid? #validation on User model before attempting customer creation in stripe
      customer = StripeWrapper::Customer.create(  #creates customer
        :card  => stripe_token,
        :user => @user,
      )
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save #saves model
        handle_invitation(invitation_token) #handles invitation if present, if not returns nothing
        AppMailer.send_welcome_email(@user).deliver #sends welcome email through email service via mailer (mailgun in this case )
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Something is wrong with your registration information. Please check errors below."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token) #invitation token is passed through to sign_up if present
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first #find invitation
      @user.follow(invitation.inviter) #new user follows the person who invited them
      invitation.inviter.follow(@user) #person who invited follows new user
      invitation.update_column(:token, nil) #removes invitation
    end
  end
end
