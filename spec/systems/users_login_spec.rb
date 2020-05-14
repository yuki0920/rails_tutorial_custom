# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersLogin', type: :system do
  let!(:user) do
    User.create!(
      name: 'Michael Example',
      email: 'michael@example.com',
      password: 'password'
    )
  end

  it 'login with valid email/invalid password' do
    visit login_path
    fill_in 'auth_email', with: user.email
    fill_in 'auth_password', with: 'invalid'
    click_button 'ログイン'
    expect(page).to have_content 'Invalid'
    visit root_path
    expect(page).to_not have_content 'Invalid'
  end

  it 'login with valid information' do
    visit login_path
    fill_in 'auth_email', with: user.email
    fill_in 'auth_password', with: user.password
    click_button 'ログイン'
    expect(page).to_not have_link 'Log in'
    expect(page).to have_link 'Settings'
    expect(page).to have_link 'Profile'
    expect(page).to have_link 'Log out'
    expect(is_logged_in?).to be_truthy
    visit user_path(user)
    click_link 'Log out'
    expect(page).to_not have_link 'Profile'
    expect(page).to_not have_link 'Log out'
  end
end
