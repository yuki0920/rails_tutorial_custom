require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: 'Example User', email: 'user@example.com') }

  it 'shold be valid' do
    expect(user.valid?).to be_truthy
  end

  it 'name should be present' do
    user.name = ' '
    expect(user.valid?).to be_falsy
  end

  it 'email should be present' do
    user.email = ' '
    expect(user.valid?).to be_falsy
  end

  it 'name should not be too long' do
    user.name = 'a' * 51
    expect(user.valid?).to be_falsy
  end


  it 'email should not be too long' do
    user.email = 'a' * 244 + '@example.com'
    expect(user.valid?).to be_falsy
  end

  it 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user.valid?).to be_truthy
    end
  end

  it 'email validation should reject invalid addresses"' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user.valid?).to be_falsy
    end
  end

  it 'email addresses should be unique' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save!
    expect(duplicate_user.valid?).to be_falsy
  end
end