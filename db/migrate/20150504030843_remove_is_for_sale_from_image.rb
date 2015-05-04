class RemoveIsForSaleFromImage < ActiveRecord::Migration
  def change
    remove_column :images, :is_for_sale
  end
end
