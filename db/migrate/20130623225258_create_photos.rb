class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos, force: true do |t|
      t.integer :collection_id
      t.string :asset
      t.text :desc
      t.timestamps
    end

    add_index :photos, :collection_id unless index_exists?(:photos, :collection_id)
  end
end
