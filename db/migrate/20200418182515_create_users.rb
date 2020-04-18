class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|

      t.string :name
      t.string :name_formatted
      t.string :email

      t.string :password_digest
      t.string :password_confirmation

      t.string :remember_digest

      t.string   :activation_digest
      t.boolean  :activated, default: false
      t.datetime :activated_at

      t.string   :reset_digest
      t.datetime :reset_sent_at

      t.boolean :admin, defaut: false

      t.timestamps null: false
    end
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
