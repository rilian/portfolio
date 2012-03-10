class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, :force => true do |t|
      t.string :title
      t.timestamps
    end
  end
end