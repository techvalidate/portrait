class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.integer :request_count, :default=>0
      t.string :pricing_model
      t.boolean :blocked, :default=>false
    end
  end
end
