class RemoveCollectionIdToPhoto < ActiveRecord::Migration
  def change
    remove_column :photos, :collection_id
  end
end
