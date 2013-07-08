class ChangeIsPublishedOnAlbum < ActiveRecord::Migration
  def change
    change_column :albums, :is_published, :boolean, null: false, default: true
  end
end
