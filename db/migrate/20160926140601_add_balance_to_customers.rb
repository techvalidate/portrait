class AddBalanceToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :balance, :decimal, precision: 8, scale: 2
  end
end
