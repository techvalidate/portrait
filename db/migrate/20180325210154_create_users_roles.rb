class CreateUsersRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :users_roles do |t|
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
