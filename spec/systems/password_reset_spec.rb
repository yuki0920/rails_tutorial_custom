# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordReset', type: :system do
  let(:user) { create(:user) }

  it 'password resets' do
    visit new_password_reset_path
    fill_in 'password_reset[email]', with: user.email
    click_button 'Submit'
    expect(page).to have_css '.alert-info'
    expect(current_path).to eq '/'
    open_email(user.email)
    current_email.click_link('Reset password')
    expect(current_path).to match(%r{password_resets/.+/edit})
    expect(find('input[name=email]', visible: false).value).to eq user.email
    fill_in 'パスワード', with: user.password
    fill_in 'パスワード(確認用)', with: user.password
    click_button 'Update password'
    expect(page).to have_link 'Log out'
    expect(page).to have_css '.alert-success'
    expect(user.reload.reset_digest).to be_nil
  end

  it 'expired token' do
    visit new_password_reset_path
    fill_in 'password_reset[email]', with: user.email
    click_button 'Submit'
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    open_email(user.email)
    current_email.click_link('Reset password')
    expect(current_path).to eq new_password_reset_path
  end
end
