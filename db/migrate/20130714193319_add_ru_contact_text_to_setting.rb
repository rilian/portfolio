class AddRuContactTextToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :contact_text_ru, :text
  end
end
