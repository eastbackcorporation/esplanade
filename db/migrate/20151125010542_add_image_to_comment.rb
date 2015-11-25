class AddImageToComment < ActiveRecord::Migration
  def change
    add_column :comments, :image, :string
  end
end
