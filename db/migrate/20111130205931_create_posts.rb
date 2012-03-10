class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, :force => true do |t|
      t.integer :category_id
      t.string :title
      t.text :body
      t.boolean :is_published, :default => false
      t.timestamps
    end

    add_index :posts, :category_id unless index_exists?(:posts, :category_id)
  end
end
