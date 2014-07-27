class RemoveFlickrAndDisqus < ActiveRecord::Migration
  def change
    remove_column :images, :flickr_photo_id
    remove_column :images, :flickr_comment_time

    remove_column :settings, :flickr_api_key
    remove_column :settings, :flickr_shared_secret
    remove_column :settings, :flickr_access_token
    remove_column :settings, :flickr_access_secret
    remove_column :settings, :disqus_shortname
    remove_column :settings, :disqus_developer
    remove_column :settings, :disqus_api_secret
    remove_column :settings, :disqus_api_key
    remove_column :settings, :disqus_access_token
  end
end
