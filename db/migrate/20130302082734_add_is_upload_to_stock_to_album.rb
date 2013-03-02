class AddIsUploadToStockToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :is_upload_to_stock, :boolean, default: true
  end
end
