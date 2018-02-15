class RemovePaperclipColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :sites, :image_file_name,    :string
    remove_column :sites, :image_content_type, :string
    remove_column :sites, :image_file_size,    :integer
    remove_column :sites, :image_updated_at,   :datetime
  end
end
