require 'rails_helper'

RSpec.describe 'UserProfile', type: :system do
  include ApplicationHelper

  let(:user) { create(:user) }
  before do
    create_list(:micropost, 31, user: user, created_at: 42.days.ago)
  end

  it do
    log_in(user)
    visit user_path(user)
    expect(page).to have_title full_title(user.name)
    expect(page).to have_selector 'h1', text: user.name
    expect(page).to have_selector 'h1>img.gravatar'
    expect(page).to have_content user.microposts.count.to_s
    expect(page).to have_selector 'div.pagination'
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_content micropost.content
    end
  end
end
