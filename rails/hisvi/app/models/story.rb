class Story < ApplicationRecord
  has_many :moments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy

  belongs_to :user
  belongs_to :category

  mount_uploader :image, ImageUploader
end
