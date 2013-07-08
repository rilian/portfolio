class RemoveTypeOnCollection < ActiveRecord::Migration
  def up
    remove_column :collections, :type
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
