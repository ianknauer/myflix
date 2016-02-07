class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new #creates new user
    @user = User.new
  end

  def show #shows user info
    @user = User.find(params[:id])
  end

  def create #creates new user through UserSignup service
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      flash[:success] = "Thank you for registering with MyFlix. Please sign in now."
      redirect_to root_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def new_with_token #new from invitation email
    invitation = Invitation.where(token: params[:token]).first #should only ever be one, but a check to solve breakages
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path #token expires after a period of time
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
