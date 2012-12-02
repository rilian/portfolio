class AddIsForSaleToImage < ActiveRecord::Migration
  def change
    add_column :images, :is_for_sale, :boolean, default: false
  end
end
