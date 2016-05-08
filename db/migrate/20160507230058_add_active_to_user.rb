class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean
  end
end
