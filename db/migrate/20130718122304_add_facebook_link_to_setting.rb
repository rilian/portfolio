class AddFacebookLinkToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :facebook_account, :string
  end
end
