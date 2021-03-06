require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    
    let(:alice) { Fabricate :user }
    let(:bob) { Fabricate :user }
    before { set_current_user(alice) }
    
    it "sets @relationships to the current user's following relationships" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  
  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 } 
    end
    
    let(:alice) { Fabricate :user }
    let(:bob) { Fabricate :user }
    before { set_current_user(alice) }
    
    it "redirects to the people page" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    it "deletes the relationship if the current user is the follower" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    
    it "doesn't delete the relationhship if the current user is not the follower" do
      charlie = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end
  
  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 4 } 
    end
    
    let(:alice) { Fabricate :user }
    let(:bob) { Fabricate :user }
    before { set_current_user(alice) }
    
    it "redirects to the people page" do
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end
    it "creates a relationship that the the current user follows the leader" do
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end
    it "doesn't create a relationship if there's already a relationship" do
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end
    it "does not allow one to follow themselves" do
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end
end