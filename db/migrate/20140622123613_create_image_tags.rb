class CreateImageTags < ActiveRecord::Migration
  def change
    create_table :image_tags do |t|
      t.references :image, index: true
      t.references :tag, index: true
      t.timestamps
    end

    add_index :image_tags, [:image_id, :tag_id], unique: true
  end
end
