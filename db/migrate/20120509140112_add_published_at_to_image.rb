class AddPublishedAtToImage < ActiveRecord::Migration
  def change
    add_column :images, :published_at, :datetime

    add_index :images, :published_at
  end
end
