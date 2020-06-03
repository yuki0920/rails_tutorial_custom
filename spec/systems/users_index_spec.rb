# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system do
  let!(:admin) { create(:user, :admin) }
  let!(:non_admin) { create(:user, :archer) }

  before do
    30.times do |n|
      User.create!(name: "User #{n}", email: "user-#{n}@example.com", password: 'password', activated: true)
    end
  end

  it 'should redirect index when not logged in' do
    visit users_path
    expect(current_path).to eq login_path
  end

  it 'index as admin including pagination and delete links' do
    log_in(admin)
    visit users_path
    expect(current_path).to eq(users_path)
    expect(page).to have_css '.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.paginate(page: 1).each do |user|
      expect(page).to have_link user.name
      unless user == admin
        expect(page).to have_link 'delete', href: user_path(user)
      end
    end
    expect { click_link 'delete', href: user_path(non_admin) }.to change(User, :count).by(-1)
  end

  it 'index as non_admin' do
    log_in(non_admin)
    visit users_path
    expect(page).to_not have_link 'delete'
  end
end
