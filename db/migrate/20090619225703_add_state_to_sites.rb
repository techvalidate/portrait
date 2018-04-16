class AddStateToSites < ActiveRecord::Migration[4.2]
  def self.up
    add_column :sites, :state, :string
  end

  def self.down
    remove_column :sites, :state
  end
end
