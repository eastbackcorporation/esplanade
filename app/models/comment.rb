class Comment < ActiveRecord::Base
  include Bootsy::Container
  belongs_to :topic
  belongs_to :user
  mount_uploader :image, ImageUploader
  enum status: [:active, :deleted]
end
