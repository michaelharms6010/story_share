class AddPasswordValidationAndStreakToUsers < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :profile_completed, :boolean, null: false, default: false
    add_column :users, :streak,  :integer, null: false, default: 0

  end
end
