class AddUniqueIndexToRssRecords < ActiveRecord::Migration
  def change
    add_index :rss_records, [:owner_type, :owner_id], unique: true
  end
end
