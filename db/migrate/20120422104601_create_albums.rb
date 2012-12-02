class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums, force: true do |t|
      t.string :title, null: false
    end

    add_index :albums, :title, unique: true
  end
end
