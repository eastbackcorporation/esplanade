class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :value
      t.integer :topic_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
