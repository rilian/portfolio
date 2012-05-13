class ChangeFlickrColumnsToImage < ActiveRecord::Migration
  def change
    remove_column :images, :is_uploaded_to_flickr

    add_column :images, :uploaded_to_flickr_at, :datetime
    add_column :images, :flickr_photo_id, :string, :limit => 11

    add_index :images, :uploaded_to_flickr_at
  end
end
