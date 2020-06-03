# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserSignup', type: :system do
  it 'invalid signup information' do
    visit signup_path
    expect do
      fill_in '名前', with: ''
      fill_in 'メールアドレス', with: 'user@invalid'
      fill_in 'パスワード', with: 'foo'
      fill_in 'パスワード(確認用)', with: 'bar'
      click_button 'Create my account'
    end.to_not change(User, :count)
    expect(page).to have_css '#error_explanation'
  end

  it 'valid signup information with account activation' do
    visit signup_path
    email = 'user@example.com'
    password = 'password'
    expect do
      fill_in '名前', with: 'Example User'
      fill_in 'メールアドレス', with: email
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード(確認用)', with: password
      click_button 'Create my account'
    end.to change(User, :count).by(1)
    expect(page).to have_css '.alert-info'
    expect(ActionMailer::Base.deliveries.size).to eq 1
    user = User.find_by!(email: email)
    expect(user.activated?).to be_falsy
    open_email(user.email)
    current_email.click_link('Activate')
    expect(user.reload.activated?).to be_truthy
    visit login_path
    fill_in 'auth_email', with: user.email
    fill_in 'auth_password', with: password
    click_button 'ログイン'
    expect(page).to have_link 'Log out'
    expect(is_logged_in?).to be_truthy
  end
end
