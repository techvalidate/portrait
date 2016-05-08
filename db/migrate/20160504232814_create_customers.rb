class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.datetime :canceled_at
      t.datetime :reactivated_at

      t.timestamps
    end

    add_column :users, :customer_id, :integer
  end
end
