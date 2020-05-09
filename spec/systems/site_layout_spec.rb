require 'rails_helper'

RSpec.describe 'SiteLayout', type: :system do
  it 'layout links' do
    visit root_path
    expect(page).to have_link, href: root_path, count: 2
    expect(page).to have_link, href: help_path
    expect(page).to have_link, href: about_path
    expect(page).to have_link, href: contact_path
    visit contact_path
    expect(page).to have_title full_title('Contact')
  end
end
