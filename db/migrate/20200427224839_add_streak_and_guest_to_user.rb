class AddStreakAndGuestToUser < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :streak, :integer, null: false, default: 0
    add_column :users, :is_guest, :boolean, null: false, default: false

  end
end
