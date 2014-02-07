class InvitationWorker
  include Sidekiq::Worker
  
  def perform(invitation_token)
    invitation = Invitation.find_by token: 'invitation_token'
  end
end