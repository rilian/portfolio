class AddBodyFullToPost < ActiveRecord::Migration
  def change
    add_column :posts, :body_full, :text
  end
end
