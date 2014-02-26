class AdminsController < ApplicationController
  before_filter :require_admin

  private
  
  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not permitted to do that"
      redirect_to home_path
    end
  end 
end