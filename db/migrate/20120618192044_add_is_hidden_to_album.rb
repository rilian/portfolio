class AddIsHiddenToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :is_hidden, :boolean, default: false

    add_index :albums, :is_hidden
  end
end
