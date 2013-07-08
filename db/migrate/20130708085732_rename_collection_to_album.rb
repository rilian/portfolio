class RenameCollectionToAlbum < ActiveRecord::Migration
  def change
    rename_table :collections, :albums

    rename_column :images, :collection_id, :album_id
  end
end
