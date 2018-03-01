class CreateSiteBatches < ActiveRecord::Migration[5.2]
  def self.up
    create_table :site_batches do |t|
      t.references :user, index: true
      t.integer :status
      t.timestamps
    end

    add_column :sites, :site_batch_id, :integer, index: true
  end

  def self.down
    drop_table :site_batches
    remove_column :sites, :site_batch_id
  end
end
