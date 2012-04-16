class AddIsPhotoToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :is_photo, :boolean, :default => false
    add_index :categories, :is_photo
  end
end
