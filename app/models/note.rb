class Note < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

    # アップロード画像の容量をバリデーションする
    def picture_size
    	if picture.size > 5.megabytes
    		errors.add(:picture, "should be less than 5MB")
    	end
    end

end
