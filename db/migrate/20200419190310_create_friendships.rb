class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id

      t.boolean :confirmed, null: false, default: false
      t.datetime :confirmed_at
      t.boolean :rejected, null: false, default: false
      t.boolean :accepted, null: false, default: false

      t.timestamps
    end
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
  end
end
