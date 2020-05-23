require 'rails_helper'

RSpec.describe 'UsersEdit', type: :system do
  let(:user) { create(:user, name: 'Michael Example', email: 'michael@example.com') }

  it 'unsuccessful edit' do
    log_in(user)
    visit edit_user_path(user)
    name = ''
    email = 'foo@invalid'
    fill_in '名前', with: name
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: 'foo'
    fill_in 'パスワード(確認用)', with: 'bar'
    click_button 'Save changes'
    expect(user.name).to_not eq(name)
    expect(user.email).to_not eq(email)
  end

  it 'successful edit with friendly forwarding' do
    visit edit_user_path(user)
    log_in(user)
    expect(current_path).to eq(edit_user_path(user))
    name = 'Foo Bar'
    email = 'foo@ba.com'
    fill_in '名前', with: name
    fill_in 'メールアドレス', with: email
    click_button 'Save changes'
    expect(page).to have_content 'Profile updates'
    user.reload
    expect(user.name).to eq(name)
    expect(user.email).to eq(email)
  end
end
