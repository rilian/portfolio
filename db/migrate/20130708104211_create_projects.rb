class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects, force: true do |t|
      t.string :title, null: false
      t.boolean :is_published, null: false, default: false
      t.text :description
    end

    add_index :projects, :is_published unless index_exists?(:projects, :is_published)
  end
end
