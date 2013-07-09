class CreateRssRecords < ActiveRecord::Migration
  def change
    create_table :rss_records, force: true do |t|
      t.string :owner_type, null: false
      t.integer :owner_id, null: false
      t.timestamps
    end

    add_index :rss_records, :created_at unless index_exists?(:rss_records, :created_at)
  end
end
