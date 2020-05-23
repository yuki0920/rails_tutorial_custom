require 'rails_helper'

RSpec.describe 'UserEdit', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, :archer) }

  it 'shoud redirect edit when not logged in' do
    get edit_user_path(user)
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect update when not logged in' do
    patch user_path(user), params: { user: { name: user.name, email: user.email } }
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect edit when logged in as wrong user' do
    log_in_as(other_user)
    get edit_user_path(user)
    expect(response).to redirect_to(root_url)
  end

  it 'should redirect update when logged in as wrong user' do
    log_in_as(other_user)
    patch user_path(user), params: { user: { name: user.name, email: user.email } }
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(root_url)
  end

  it 'should not allow the admin attribute to be edited via the web' do
    log_in_as(user)
    patch user_path(user), params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
    expect(user.reload.admin?).to be_falsy
  end
end
