class AddTagsCacheToImage < ActiveRecord::Migration
  def change
    add_column :images, :tags_cache, :string
  end
end
