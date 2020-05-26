class AddViewedToComment < ActiveRecord::Migration[6.0]
  def change

    add_column :comments, :viewed,  :boolean, null: false, default: false
    add_index :comments, :viewed

  end
end
