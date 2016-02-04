class Comment < ActiveRecord::Base
  include Bootsy::Container
  validates :value, presence: true

  belongs_to :topic
  belongs_to :user
  enum status: [:active, :deleted]
end
