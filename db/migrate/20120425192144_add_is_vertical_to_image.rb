class AddIsVerticalToImage < ActiveRecord::Migration
  def change
    add_column :images, :is_vertical, :boolean
  end
end
