class AddEmailToUsers < ActiveRecord::Migration
  def up
    add_column :users, :email, :string, limit: 255
  end
  def down
    remove_column :users, :email
  end
end
