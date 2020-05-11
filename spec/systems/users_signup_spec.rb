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

  it 'valid signup information' do
    visit signup_path
    expect do
      fill_in '名前', with: 'Example User'
      fill_in 'メールアドレス', with: 'user@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード(確認用)', with: 'password'
      click_button 'Create my account'
    end.to change(User, :count).by(1)
    expect(page).to have_css '.alert-success'
  end
end
