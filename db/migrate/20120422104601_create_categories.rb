class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, :force => true do |t|
      t.string :title, :null => false
    end

    add_index :categories, :title, :unique => true
  end
end
