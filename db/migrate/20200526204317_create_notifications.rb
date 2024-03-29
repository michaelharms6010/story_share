class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id

      t.string  :comment_id

      t.boolean :viewed, null: false, default: false
    end
    add_index :notifications, :user_id
    add_index :notifications, :comment_id
    add_index :notifications, :viewed
  end
end
