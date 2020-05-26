class AddNotificationsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column    :users, :notifications, :jsonb, null: false, default: {}
  end
end
