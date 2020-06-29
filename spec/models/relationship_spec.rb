require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, :archer) }
  let(:relationship) { Relationship.new(follower: user, followed: other_user) }

  it 'should be valid' do
    expect(relationship.valid?).to be_truthy
  end

  it 'should require a  follower_id' do
    relationship.follower_id = nil
    expect(relationship.valid?).to be_falsy
  end

  it 'should require a followed_id' do
    relationship.followed_id = nil
    expect(relationship.valid?).to be_falsy
  end

  it 'should follower and unfollow a user' do
    expect(user.following?(other_user)).to be_falsy
    user.follow(other_user)
    expect(user.following?(other_user)).to be_truthy
    expect(other_user.followers.include?(user)).to be_truthy
    user.unfollow(other_user)
    expect(user.following?(other_user)).to be_falsy
  end
end
