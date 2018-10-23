class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.content_max_size}
  validate :picture_size

  scope :time_created, ->{order(created_at: :desc)}
  scope :post_of_user, ->(id){where("user_id = ?", id)}
  private

  def picture_size
    return unless picture.size > Settings.img_max_size.megabytes
    errors.add(:picture, I18n.t(".img_size_errors"))
  end
end
