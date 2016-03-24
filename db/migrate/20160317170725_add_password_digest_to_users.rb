class AddPasswordDigestToUsers < ActiveRecord::Migration
  def up
    add_column :users, :password_digest, :string, limit: 255

    remove_column :users, :password
  end

  def down
    add_column :users, :password, :string
    remove_column :users, :password_digest
  end
end
