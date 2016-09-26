class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.datetime :canceled_at

      t.timestamps null: false
    end

    # add customer ref to users
    add_reference :users, :customer, index: true
  end
end
