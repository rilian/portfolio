class AddWeightAndShortDescriptionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :weight, :integer, null: false, default: 0
    add_column :projects, :info, :text

    add_index :projects, :weight
  end
end
