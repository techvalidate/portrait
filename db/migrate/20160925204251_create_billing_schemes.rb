class CreateBillingSchemes < ActiveRecord::Migration
  def change
    create_table :billing_schemes do |t|
      t.string :name

      t.timestamps null: false
    end

    add_reference :customers, :billing_scheme, index: true
  end
end
