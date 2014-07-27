class RemoveUnusedColumnsFromImage < ActiveRecord::Migration
  def change
    remove_column :images, :deviantart_link
    remove_column :images, :istockphoto_link
    remove_column :images, :shutterstock_link
  end
end
