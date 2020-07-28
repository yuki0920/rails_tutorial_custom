class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy, foreign_key: 'room_id'
  has_many :users, through: :room_users
  has_many :messages, dependent: :destroy

  def create_room(from, to)
    self.room_users.create!(user_id: from.id)
    self.room_users.create!(user_id: to.id)
  end
end
