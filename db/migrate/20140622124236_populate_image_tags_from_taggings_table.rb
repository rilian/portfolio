class PopulateImageTagsFromTaggingsTable < ActiveRecord::Migration
  def up
    execute 'DELETE FROM image_tags'
    execute 'INSERT INTO image_tags(image_id,tag_id,created_at) SELECT taggable_id,tag_id,created_at FROM taggings'
    puts "Populated #{ImageTag.count} image tags"
  end

  def down
    execute 'DELETE FROM image_tags;'

    puts "Populated #{ImageTag.count} image tags"
  end
end
