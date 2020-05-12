class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|

      t.integer :story_id
      t.integer :commenter_id

      t.text    :text, default: "", null: false

      t.integer :visibility, null: false, default: 0
    end
    add_index :comments, :story_id
    add_index :comments, :commenter_id
  end
end
