class Topic < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :comments

  enum status: [:active, :archived, :deleted]
end
