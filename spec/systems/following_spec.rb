require 'rails_helper'

RSpec.describe 'Following', type: :system do
  let(:user) { create(:user) }
  let(:lana) { create(:user, :lana) }
  let(:malory) { create(:user, :malory) }
  let(:archer) { create(:user, :archer) }
  before do
    log_in(user, password: 'password')
    create(:relationship, follower_id: user.id, followed_id: lana.id)
    create(:relationship, follower_id: user.id, followed_id: malory.id)
    create(:relationship, follower_id: lana.id, followed_id: user.id)
    create(:relationship, follower_id: archer.id, followed_id: user.id)
  end

  it 'following page' do
    visit following_user_path(user)
    expect(user.following.empty?).to be_falsy
    expect(page.body).to have_content user.following.count.to_s
    user.following.each do |u|
      expect(page.body).to have_link u.name, href: user_path(u)
    end
  end

  it 'followers page' do
    visit followers_user_path(user)
    expect(user.followers.empty?).to be_falsy
    expect(page.body).to have_content user.followers.count.to_s
    user.followers.each do |u|
      expect(page.body).to have_link u.name, href: user_path(u)
    end
  end
end
