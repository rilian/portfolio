class RenameRuToUa < ActiveRecord::Migration
  def change
    rename_column :albums, :title_ru, :title_ua
    rename_column :albums, :description_ru, :description_ua

    rename_column :images, :title_ru, :title_ua
    rename_column :images, :place_ru, :place_ua
    rename_column :images, :desc_ru, :desc_ua

    rename_column :photos, :desc_ru, :desc_ua

    rename_column :projects, :title_ru, :title_ua
    rename_column :projects, :description_ru, :description_ua
    rename_column :projects, :info_ru, :info_ua

    rename_column :settings, :contact_text_ru, :contact_text_ua
  end
end
