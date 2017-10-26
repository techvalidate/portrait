class IndexSitesCreatedAt < ActiveRecord::Migration[5.1]
  def change
    # For `clean` rake task
    add_index :sites, :created_at
  end
end
