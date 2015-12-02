class AddStatusToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :status, :integer, default: Topic.statuses[:active]
  end
end
