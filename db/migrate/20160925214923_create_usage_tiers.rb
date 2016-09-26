class CreateUsageTiers < ActiveRecord::Migration
  def change
    create_table :usage_tiers do |t|
      t.integer :start
      t.decimal :price_per, precision: 8, scale: 2
      t.belongs_to :billing_scheme, index: true

      t.timestamps null: false
    end
  end
end
