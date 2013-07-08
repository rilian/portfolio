class AddIsCoverToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :is_cover, :boolean, null: false, default: false
  end
end
