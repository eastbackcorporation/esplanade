class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer, default: User.statuses[:active]
  end
end
