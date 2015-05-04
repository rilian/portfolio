class RemoveIsUploadToStockFromAlbum < ActiveRecord::Migration
  def change
    remove_column :albums, :is_upload_to_stock
  end
end
