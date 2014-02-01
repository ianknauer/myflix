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
    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      redirect_to root_path
    else
      render :new
    end
  end
  
  def new_with_invitation_token
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end