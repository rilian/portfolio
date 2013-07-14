class AddRuLocaleContentFields < ActiveRecord::Migration
  def change
    add_column :albums, :title_ru, :string
    add_column :albums, :description_ru, :text

    add_column :images, :title_ru, :string
    add_column :images, :place_ru, :string
    add_column :images, :desc_ru, :text

    add_column :photos, :desc_ru, :text

    add_column :projects, :title_ru, :string
    add_column :projects, :description_ru, :text
    add_column :projects, :info_ru, :text
  end
end
