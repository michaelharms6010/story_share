class AddInvitesAndTimeZoneToUser < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :last_name,  :string, null: false, default: ""
    add_column :users, :show_full_name, :boolean, null: false, default: false

    add_column :users, :time_zone, :string, null: false, default: "Pacific Time (US & Canada)"

    add_column :users, :invited_by, :integer
    add_index  :users, :invited_by

  end
end
