require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:user) { create(:user) }
  let(:lana) { create(:user, :lana) }
  let(:archer) { create(:user, :archer) }
  let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: lana.id) }


  describe 'auth' do
    it 'create should require logged-in user' do
      expect {
        post relationships_path
      }.to_not change(Relationship, :count)
      expect(response).to redirect_to login_url
    end

    it 'delete should require logged-in user' do
      expect {
        delete relationship_path(relationship)
      }.to_not change(Relationship, :count)
      expect(response).to redirect_to login_url
    end
  end

  describe 'follow' do
    before do
      log_in_as(user)
    end

    it 'should follow a user the standard way' do
      expect{
        post relationships_path, params: { followed_id: archer.id }
      }.to change(Relationship, :count)
    end

    it 'should follow a user the standard way with ajax' do
      expect{
        post relationships_path, xhr: true, params: { followed_id: archer.id }
      }.to change(Relationship, :count)
    end

    it 'should unfollow a user the standard way' do
      relationship = user.active_relationships.find_by(followed_id: lana.id)
      expect{
        delete relationship_path(relationship)
      }.to change(Relationship, :count)
    end

    it 'should unfollow a user the standard way' do
      relationship = user.active_relationships.find_by(followed_id: lana.id)
      expect{
        delete relationship_path(relationship), xhr: true
      }.to change(Relationship, :count)
    end
  end
end
