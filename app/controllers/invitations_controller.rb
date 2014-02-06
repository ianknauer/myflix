class InvitationsController < ApplicationController
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      InvitationWorker.perform_async(@invitation.token)
      flash[:success] = "You have invited #{@invitation.recipient_name} to myflix!"
      redirect_to new_invitation_path
    else
      flash[:error] = "Do you feel lucky? well, do you?"
      render :new
    end
  end
  
  private 
  
  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end