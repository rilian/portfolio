class RemoveUploadedToFlickrAtToImage < ActiveRecord::Migration
  def change
    remove_column :images, :uploaded_to_flickr_at
  end
end
