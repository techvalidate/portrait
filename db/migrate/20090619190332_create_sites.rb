class CreateSites < ActiveRecord::Migration[4.2]
  def self.up
    create_table :sites do |t|
      t.string   :url, :image_file_name, :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
