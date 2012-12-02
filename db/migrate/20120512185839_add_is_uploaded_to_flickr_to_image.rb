class AddIsUploadedToFlickrToImage < ActiveRecord::Migration
  def change
    add_column :images, :is_uploaded_to_flickr, :boolean, default: false

    add_index :images, :is_uploaded_to_flickr
  end
end
