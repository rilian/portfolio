class ConvertAlbumsToCollections < ActiveRecord::Migration
  def change
    rename_table :albums, :collections

    add_column :collections, :type, :string

    begin
      Collection.all.each do |c|
        c.update_attribute(:type, 'Album')
      end
    rescue
      puts 'data migration failed. skipping'
    end

    rename_column :images, :album_id, :collection_id
  end
end
