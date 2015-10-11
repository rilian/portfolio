class AddTypeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :type, :string, null: false, default: 'project'
  end
end
