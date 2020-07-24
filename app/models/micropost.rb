class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }

  before_save :set_reply_user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,
    content_type: {
      in: %w[image/jpeg image/gif image/png],
      message: "must be a balid image formt"
    },
    size: {
      less_than: 5.megabytes,
      message: "should be less than 5MB"
    }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  private

  def set_reply_user
    return unless user_nickname = content.match(/(?<=@)\w+/)

    self.in_reply_to = user_nickname[0]
  end
end
