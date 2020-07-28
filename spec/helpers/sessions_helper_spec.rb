require 'rails_helper'

RSpec.describe SessionsHelper do
  let(:user) { create :user }

  before do
    remember(user)
  end

  it 'current_user returns right user when session is nil' do
    expect(current_user).to eq user
    expect(session[:user_id]).to_not be_nil
    expect(cookies.signed[:user_id]).to_not be_nil
  end

  it 'current_user returns nil when remember digest is wrong' do
    user.update_attribute(:remember_digest, User.digest(User.new_token))
    expect(current_user).to be_nil
  end
end
