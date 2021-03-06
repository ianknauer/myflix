class ForgotPasswordsController < ApplicationController

  def create
    user = User.where(email: params[:email]).first
    if user 
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank." : "Unable to send email, please try again"
      redirect_to forgot_password_path
    end
  end
end