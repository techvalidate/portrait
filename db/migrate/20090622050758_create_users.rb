class CreateUsers < ActiveRecord::Migration[4.2]
  def self.up
    create_table :users do |t|
      t.string  :name, :password
      t.boolean :admin, :default=>false
      t.integer :sites_count, :default=>0
      t.timestamps
    end

    add_column :sites, :user_id, :integer
    add_index  :sites, :user_id
  end

  def self.down
    drop_table :users
    remove_column :sites, :user_id
  end
end
