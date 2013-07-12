class AddContactTextToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :contact_text, :text
  end
end
