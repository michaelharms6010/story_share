class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|

      t.string :prompt, null: false, default: ""
      t.string :length, null: false, default: "MEDIUM"

      t.timestamps null: false

    end
    add_index :topics, :length
  end
end
