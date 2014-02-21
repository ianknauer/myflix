class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :card  => params[:stripeToken],
        :amount      => 999,
        :description => "Sign up charge for #{@user.email}",
      )
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.send_welcome_email(@user).deliver
        flash[:success] = "Thank you for registering with MyFlix. Please sign in now."
        redirect_to root_path
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
      flash[:error] = "Something is wrong with your registration information. Please check errors below."
      render :new
    end
  end
  
  def new_with_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
  
  private 
  
  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end