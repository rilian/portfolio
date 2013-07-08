class AddWeightToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :weight, :integer, null: false, default: 0
  end
end
