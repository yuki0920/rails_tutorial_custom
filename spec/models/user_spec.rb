# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(
      name: 'Example User',
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

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
    user.save!
    expect(duplicate_user.valid?).to be_falsy
  end

  it 'password should be present (nonblank)' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user.valid?).to be_falsy
  end

  it 'password should have a minimum length' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user.valid?).to be_falsy
  end

  it 'password should not be all the same' do
    user.password = user.password_confirmation = 'a' * 6
    expect(user.valid?).to be_falsy
    expect(user.errors.messages[:password]).to include("Can't be all the same")
  end
end
