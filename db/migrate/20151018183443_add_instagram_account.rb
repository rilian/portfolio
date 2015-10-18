class AddInstagramAccount < ActiveRecord::Migration
  def change
    add_column :settings, :instagram_account, :string
  end
end
