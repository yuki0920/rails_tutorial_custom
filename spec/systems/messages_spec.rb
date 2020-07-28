require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  let(:user) { create(:user, nickname: 'michael') }
  let(:other_user) { create(:user, :archer, nickname: 'archer') }
  let(:room) { Room.create! }
  before do
    user.follow(other_user)
    other_user.follow(user)
    room.create_room(user, other_user)
  end

  it 'can display messages in real time', js: true do
    log_in(user)
    visit room_path(room)
    message = 'Hello'
    expect{
      fill_in 'Write a message', with: message
      find('#message').send_keys(:enter)
    }.to change(Message, :count).by(1)
    expect(page).to have_content message
  end
end
