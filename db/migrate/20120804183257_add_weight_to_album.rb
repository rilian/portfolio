class AddWeightToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :weight, :integer, :default => 0
    add_index :albums, :weight
  end
end
