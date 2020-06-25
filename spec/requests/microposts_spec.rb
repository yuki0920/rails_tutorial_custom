require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, :archer) }
  let!(:micropost) { create(:micropost, user: user) }
  let!(:other_micropost) { create(:micropost, user: other_user) }

  it 'should redirect create when not logged in' do
    expect {
      post microposts_path, params: { micropost: { content: 'Lorem ipsum' } }
    }.to_not change(Micropost, :count)
    expect(response).to redirect_to(login_url)
  end

  it 'should redirct destrooy when not logged in' do
    expect {
      delete micropost_path(micropost)
    }.to_not change(Micropost, :count)
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect destroy for wrong micropost' do
    log_in_as user
    micropost = other_micropost
    expect{
      delete micropost_path(micropost)
    }.to_not change(Micropost, :count)
    expect(response).to redirect_to(root_url)
  end
end
