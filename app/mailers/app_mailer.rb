class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@mylix.ca", subject: "Welcome to myflix"
  end
  
  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.ca", subject: "Please reset your password"
  end
end