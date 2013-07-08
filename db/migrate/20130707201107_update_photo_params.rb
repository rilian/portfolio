class UpdatePhotoParams < ActiveRecord::Migration
  def change
    add_column :photos, :image_width, :integer
    add_column :photos, :image_height, :integer

    add_column :photos, :owner_type, :string
    add_column :photos, :owner_id, :integer
  end
end
