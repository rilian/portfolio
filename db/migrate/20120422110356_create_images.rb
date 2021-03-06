class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, force: true do |t|
      t.integer :album_id
      t.string :asset
      t.string :title
      t.string :place
      t.text :desc
      t.date :date

      t.timestamps
    end

    add_index :images, :album_id unless index_exists?(:images, :album_id)
  end
end
