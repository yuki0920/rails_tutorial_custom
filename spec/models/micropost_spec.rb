require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(content: "Lorem ipsum") }
  let(:most_recent_post) { create(:micropost, user: user, created_at: Time.zone.now) }

  before do
    create(:micropost, user: user, created_at: 10.minutes.ago)
    create(:micropost, user: user, created_at: 3.years.ago)
    create(:micropost, user: user, created_at: 2.hours.ago)
  end

  it 'shoud be valid' do
    expect(micropost.valid?).to be_truthy
  end

  it 'user id should be present' do
    micropost.user_id = nil
    expect(micropost.valid?).to be_falsy
  end

  it 'content should be present' do
    micropost.content = " "
    expect(micropost.valid?).to be_falsy
  end

  it 'content should be at most 140 characters' do
    micropost.content = "a" * 141
    expect(micropost.valid?).to be_falsy
  end

  it 'order should be most recent first' do
    expect(most_recent_post).to eq(Micropost.first)
  end

  it 'associated microposts should be destroyed' do
    other_user = create(:user)
    other_user.microposts.create!(content: 'Lorem ipsum')
    expect{other_user.destroy}.to change(Micropost, :count).by(-1)
  end
end
