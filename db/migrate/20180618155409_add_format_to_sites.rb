class AddFormatToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :format, :string, default: 'png'
  end
end
