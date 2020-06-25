# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MicropostInterface', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, :archer) }
  before do
    create_list(:micropost, 31, user: user)
  end

  it 'micropost interface' do
    log_in(user)
    visit root_path
    expect(page).to have_selector 'div.pagination'
    expect{
      fill_in 'micropost[content]', with: ''
      click_button 'Post'
    }.to_not change(Micropost, :count)
    content = 'This micropost really ties the room together'
    expect{
      fill_in 'micropost[content]', with: content
      attach_file 'micropost[image]', "#{Rails.root}/spec/factories/profile_image.jpg"
      click_button 'Post'
    }.to change(Micropost, :count).by(1)
    expect(current_path).to eq(root_path)
    expect(page).to have_content content
    last_micropost = user.microposts.first
    expect(last_micropost.image.attached?).to be_truthy
    expect{
      within "#micropost-#{last_micropost.id}" do
        click_link('delete')
      end
    }.to change(Micropost, :count).by(-1)
    visit user_path(other_user)
    expect(page).to_not have_link 'delete'
  end

  it 'micropost sidebar count' do
    log_in(user)
    visit root_path
    expect(page).to have_content '31 micropost'
    log_in(other_user)
    visit root_path
    expect(page).to have_content '0 micropost'
    other_user.microposts.create!(content: 'A micropost')
    visit root_path
    expect(page).to have_content '1 micropost'
  end
end
