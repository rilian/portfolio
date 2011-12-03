class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, :default => 'Untitled'
      t.text :body, :default => 'Post body'
      t.integer :category_id
      t.boolean :is_published, :default => false
      t.timestamps
    end
  end
end
