class AddIndexPostIdToImages < ActiveRecord::Migration
  def change
    add_index :images, :post_id
  end
end
