class AddValueToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :value, :text
  end
end
