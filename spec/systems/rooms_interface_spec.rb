# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RoomsInterface', type: :system do
  let(:user) { create(:user, nickname: 'michael') }
  let(:other_user) { create(:user, :archer, nickname: 'archer') }
  before do
    user.follow(other_user)
  end

  it 'rooms interface' do
    log_in(user)
    visit rooms_path

    expect{
      fill_in '@nickname', with: '@wrong_user'
      click_on 'Follow user invite!'
    }.to_not change(Room, :count)
    expect(page).to have_content 'ユーザーが見つかりません。'

    expect{
      fill_in '@nickname', with: '@archer'
      click_on 'Follow user invite!'
    }.to_not change(Room, :count)
    expect(page).to have_content '相互フォロワーのみ使えます。'

    other_user.follow(user)
    expect{
      fill_in '@nickname', with: '@archer'
      click_on 'Follow user invite!'
    }.to change(Room, :count).by(1)
    expect(page).to have_content '@michael @archer'

    visit rooms_path
    expect{
      fill_in '@nickname', with: '@archer'
      click_on 'Follow user invite!'
    }.to_not change(Room, :count)
    expect(page).to have_content 'すでに作成されたroomへ移動しました。'
  end
end
