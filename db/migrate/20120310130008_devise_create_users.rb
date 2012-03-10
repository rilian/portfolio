class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      t.timestamps
    end

    add_column :users, :username, :string

    add_index :users, :email, :unique => true
    add_index :users, :username, :unique => true
  end
end
