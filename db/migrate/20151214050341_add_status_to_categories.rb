class AddStatusToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :status, :integer, default: Category.statuses[:active]
  end
end
