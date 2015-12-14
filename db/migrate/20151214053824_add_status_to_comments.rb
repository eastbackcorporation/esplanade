class AddStatusToComments < ActiveRecord::Migration
  def change
    add_column :comments, :status, :integer, default: Comment.statuses[:active]
  end
end
