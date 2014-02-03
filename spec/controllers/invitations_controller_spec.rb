require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end
  
  describe "POST new" do
    
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    
    context "with valid inputs" do
      
      after { ActionMailer::Base.deliveries.clear }
      
      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "joe smith", recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(response).to redirect_to new_invitation_path
      end
      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "joe smith", recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(Invitation.count).to eq(1) 
      end
      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "joe smith", recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe.smith@gmail.com'])
      end
      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "joe smith", recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(flash[:success]).to be_present
      end
    end
    context "with invalid inputs" do
      it "renders the :new template" do
        set_current_user
        post :create, invitation: { recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(response).to render_template(:new)
      end
      it "doesn't create an invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(Invitation.count).to eq(0)
      end
      it "doesn't send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(flash[:error]).to be_present
      end
      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe.smith@gmail.com", message: "Hello joe, please join me on this wicked awesome site!" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end