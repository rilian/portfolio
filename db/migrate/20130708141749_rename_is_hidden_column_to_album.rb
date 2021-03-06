class RenameIsHiddenColumnToAlbum < ActiveRecord::Migration
  def change
    rename_column :albums, :is_hidden, :is_published

    Album.all.each { |a| a.update_attribute(:is_published, !a.is_published?) }
  end
end
