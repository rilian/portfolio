# Learn more: http://github.com/javan/whenever

every 30.minutes do
  rake 'images:publish_unpublished'
end
