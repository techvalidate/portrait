class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end

    add_column :users, :customer_id, :integer
    add_index  :users, :customer_id
  end
end
