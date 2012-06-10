class AddDeviantartIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :deviantart_id, :string, :limit => 8
  end
end
