require 'rails_helper'

RSpec.describe 'UserLogin', type: :request do
  let(:user) { create :user }

  it 'login with followed by logout' do
    post login_path, params: { session: { email: user.email, password: 'password' } }
    expect(session[:user_id].present?).to be_truthy
    delete logout_path
    expect(response).to have_http_status 302
    expect(session[:user_id].present?).to be_falsy
    expect{ delete logout_path }.to_not raise_error
  end

  it 'login with remembering' do
    log_in_as(user, remember_me: '1')
    expect(cookies[:remember_token]).to_not be_nil
  end

  it 'ligin without remembering' do
    log_in_as(user, remember_me: '0')
    expect(cookies[:remember_token]).to be_nil
  end
end
