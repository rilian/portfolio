class AddIndexesToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :is_published
  end
end
