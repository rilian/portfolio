class UpdatePhotoParams < ActiveRecord::Migration
  def change
    add_column :photos, :image_width, :integer
    add_column :photos, :image_height, :integer

    add_column :photos, :owner_type, :string, null: false
    add_column :photos, :owner_id, :integer, null: false
  end
end
