class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, :force => true do |t|
      t.integer :post_id
      t.string :asset

      t.timestamps
    end

    add_index :images, :post_id unless index_exists?(:images, :post_id)
  end
end
