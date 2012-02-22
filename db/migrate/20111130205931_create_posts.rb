class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, :force => true do |t|
      t.integer :category_id
      t.string :title
      t.text :body
      t.boolean :is_published, :default => false
      t.timestamps
    end
  end
end
