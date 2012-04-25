class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, :force => true do |t|
      t.integer :category_id
      t.string :asset
      t.string :title
      t.text :desc

      t.timestamps
    end

    add_index :images, :category_id unless index_exists?(:images, :category_id)
  end
end
