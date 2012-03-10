class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, :force => true do |t|
      t.integer :post_id
      t.string :asset

      t.timestamps
    end
  end
end
