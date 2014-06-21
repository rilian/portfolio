# Learn more: http://github.com/javan/whenever

every 30.minutes do
  rake 'images:publish_unpublished'
end

every 6.hours do
  rake 'flickraw:upload_images'
end

every 1.hours do
  rake 'flickraw:update_images_data'
end

#every 2.hours do
#  rake 'flickraw:post_comments_to_disqus'
#end

every 1.days do
  rake 'flickraw:remove_deleted_on_site'
end
