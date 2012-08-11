class SetPhotobankFieldsToImage < ActiveRecord::Migration
  def change
    remove_column :images, :deviantart_id

    add_column :images, :deviantart_link, :string
    add_column :images, :istockphoto_link, :string
    add_column :images, :shutterstock_link, :string
  end
end
