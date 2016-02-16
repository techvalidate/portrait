class AddIndexWithUniqueConstraintToUsersName < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      add_index :users, :name, unique: true
    end
  end
end
