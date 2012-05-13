class RemoveIsVerticalToImage < ActiveRecord::Migration
  def change
    remove_column :images, :is_vertical
  end
end
