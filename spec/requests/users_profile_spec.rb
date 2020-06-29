require 'rails_helper'

RSpec.describe 'UsersProfile', type: :system do
  let!(:user) { create(:user) }

  it "should redirect following when not logged in" do
    get following_user_path(user)
    expect(response).to redirect_to(login_url)
  end

  it "should redirect followers when not logged in" do
    get followers_user_path(user)
    expect(response).to redirect_to(login_url)
  end
end
