# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :room_users, dependent: :destroy, foreign_key: 'user_id'
  has_many :rooms, through: :room_users
  has_many :messages, dependent: :destroy


  before_save :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validate :password_check
  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.blank?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_token, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where(user_id: self.id).or(Micropost.where(user_id: following.ids)).or(Micropost.where(in_reply_to: self.nickname))
  end

  def follow(other)
    following << other
  end

  def unfollow(other)
    following.delete(other)
  end

  def following?(other)
    following.include?(other)
  end

  def at_nickname
    "@#{nickname}"
  end

  def self.at_nickname_user(nickname)
    return false unless nickname = nickname.match(/(?<=@)[\w-]+/)

    return false unless user = User.find_by(nickname: nickname[0])

    user
  end

  def mutual_followers?(other_user)
    following?(other_user) && other_user.following?(self)
  end

  def invite_room_exist?(other_user)
    return false unless room = self.rooms.each {|room| room.users.find(other_user.id) }.first

    room
  end

  private

  def password_check
    return if password.blank?

    if password.split('').uniq.count == 1
      errors.add(:password, "Can't be all the same")
    end
  end

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
