class AddElementToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :selector, :string
  end
end
