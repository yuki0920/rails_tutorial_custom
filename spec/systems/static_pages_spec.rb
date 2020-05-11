# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  it 'should get root' do
    visit root_path
    expect(page).to have_title base_title
  end

  it 'shoul get help' do
    visit help_path
    expect(page).to have_title "Help | #{base_title}"
  end

  it 'should get about' do
    visit about_path
    expect(page).to have_title "About | #{base_title}"
  end

  it 'should get contact' do
    visit contact_path
    expect(page).to have_title "Contact | #{base_title}"
  end
end
