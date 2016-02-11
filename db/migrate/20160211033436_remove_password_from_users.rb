class RemovePasswordFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :password, 'string'
  end

  def down
    raise ActiveRecord::IrreversibleMigration # there is no way to unencrypt encrypted passwords
  end
end
