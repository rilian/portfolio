require 'flickraw'

namespace :flickraw do
  desc "Communicates with Flickr API to get OAuth access tokens for app"
  task :get_flickr_tokens => :environment do
    puts "Please refer to http://www.flickr.com/services/api/ to get your Flickr API key and secret. Put them into site config"
    puts "Current Flickr api_key=#{SITE[:flickr_api_key]} and secret=#{SITE[:flickr_shared_secret]}"

    return if SITE[:flickr_api_key].empty? || SITE[:flickr_shared_secret].empty?

    FlickRaw.api_key = SITE[:flickr_api_key]
    FlickRaw.shared_secret = SITE[:flickr_shared_secret]

    if ENV['oauth_token'].present? && ENV['oauth_token_secret'].present? && ENV['verify'].present?
      begin
      flickr.get_access_token(ENV['oauth_token'], ENV['oauth_token_secret'], ENV['verify'])
        login = flickr.test.login
        puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
        puts "Put in the site config file:\n
          :flickr_access_token: #{flickr.access_token}
          :flickr_access_secret: #{flickr.access_secret}"
      rescue FlickRaw::FailedResponse => e
        puts "Authentication failed : #{e.msg}"
      end
    else
      token = flickr.get_request_token
      auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

      puts "Open this url in your process to complete the authication process : #{auth_url}"
      puts "Confirm access for the app"
      puts "run in console: \n\nrake flickraw:get_flickr_tokens oauth_token=#{token['oauth_token']} oauth_token_secret=#{token['oauth_token_secret']} verify="
    end
  end

  desc "Uploads published Images to Flickr"
  task :upload_images => :environment do
    if SITE[:flickr_api_key].empty? || SITE[:flickr_shared_secret].empty? ||
        SITE[:flickr_access_token].empty? || SITE[:flickr_access_secret].empty?
      puts "Error: not all Flickr api keys present"
    end

    puts "Starting upload images"

    image_to_upload = Image.published.not_from_hidden_album.readonly(false).where('images.uploaded_to_flickr_at IS NULL AND images.created_at < ?', (Time.now - 30.minutes)).order('images.published_at DESC').limit(1).first

    if image_to_upload
      FlickRaw.api_key = SITE[:flickr_api_key]
      FlickRaw.shared_secret = SITE[:flickr_shared_secret]

      flickr.access_token = SITE[:flickr_access_token]
      flickr.access_secret = SITE[:flickr_access_secret]

      login = flickr.test.login

      puts "You are now authenticated as #{login.username}"

      puts 'Uploading ...'
      flickr_photo_id = flickr.upload_photo(image_to_upload.asset.path,
                                  :title => image_to_upload.title,
                                  :description => image_to_upload.render_data)
      puts "Image uploaded id = #{flickr_photo_id}"
      puts "Updating tags"

      flickr.photos.addTags(:photo_id => flickr_photo_id, :tags => image_to_upload.tags_resolved)
      puts "Tags updated"

      puts "Getting list of Flickr photosets (albums)"
      photosets = flickr.photosets.getList

      if photosets.map(&:title).include?(image_to_upload.album.title)
        # Add
        photoset_id = photosets.select {|p| p['title'] == image_to_upload.album.title}[0]['id']
        puts "Adding image #{flickr_photo_id} to photoset #{photoset_id}"
        flickr.photosets.addPhoto(:photoset_id => photoset_id, :photo_id => flickr_photo_id)
      else
        # Create photoset
        puts "Creating photoset '#{image_to_upload.album.title}'"
        flickr.photosets.create(:title => image_to_upload.album.title, :description => '',:primary_photo_id => flickr_photo_id)
        puts "Image #{flickr_photo_id} set as primary in photoset #{image_to_upload.album.title}"
      end

      image_to_upload.update_attributes({:uploaded_to_flickr_at => Time.now, :flickr_photo_id => flickr_photo_id})
    else
      puts "No images to upload"
    end
  end
end
