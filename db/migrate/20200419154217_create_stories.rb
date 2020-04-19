class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|

      t.integer :word_count, null: false, default: 0
      t.text :text, null: false, default: ''

      t.integer :visibility, null: false, default: 0

      t.timestamps null: false

    end

    # Create foreign keys: user_id and topic_id columns
    add_reference :stories, :user, foreign_key: true
    add_reference :stories, :topic, foreign_key: true

    add_index :stories, :visibility
  end
end
