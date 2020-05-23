require 'rails_helper'

RSpec.describe 'Users.destroy' do
  let!(:user) { create(:user, :admin) }
  let!(:other_user) { create(:user, :archer) }

  it 'can not destroy when not logged in' do
    expect { delete user_path(user) }.to_not change(User, :count)
  end

  it 'can not destroy when logged in as a non-admin' do
    log_in_as(other_user)
    expect { delete user_path(user) }.to_not change(User, :count)
  end
end
