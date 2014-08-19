class MakeIsPublishedDefaultTrueToProject < ActiveRecord::Migration
  def change
    change_column :projects, :is_published, :boolean, null: false, default: true

    Project.all.update_all(is_published: true)
  end
end
