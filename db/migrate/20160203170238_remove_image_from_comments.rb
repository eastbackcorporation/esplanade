class RemoveImageFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :image, :string
  end
end
