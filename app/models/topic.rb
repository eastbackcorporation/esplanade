class Topic < ActiveRecord::Base
  include Bootsy::Container
  belongs_to :category
  belongs_to :user
  has_many :comments

  enum status: [:active, :archived, :deleted]
end
