class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|

      t.integer :story_id
      t.integer :user_id  # Commenter

      t.text    :text, default: "", null: false

      t.integer :visibility, null: false, default: 0

      t.timestamps null: false
    end
    add_index :comments, :story_id
    add_index :comments, :user_id
  end
end
