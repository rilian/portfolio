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
      puts "Error: not all Flickr api keys present. Please run\n\nrake flickraw:get_flickr_tokens"
      return
    end

    puts "Starting upload images"

    image_to_upload = Image.published.not_from_hidden_album.readonly(false).
        where('images.uploaded_to_flickr_at IS NULL AND images.created_at < ?', (Time.now - 30.minutes)).order('images.published_at ASC').limit(1).first

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
        flickr.photosets.create(:title => image_to_upload.album.title, :description => '', :primary_photo_id => flickr_photo_id)
        puts "Image #{flickr_photo_id} set as primary in photoset #{image_to_upload.album.title}"
      end

      time_now = Time.now
      image_to_upload.update_attributes({:uploaded_to_flickr_at => time_now, :flickr_photo_id => flickr_photo_id, :updated_at => time_now})
    else
      puts "No images to upload"
    end
  end

  desc "Updates metadata on Flickr images, which are changed in the last week"
  task :update_images_data => :environment do
    if SITE[:flickr_api_key].empty? || SITE[:flickr_shared_secret].empty? ||
        SITE[:flickr_access_token].empty? || SITE[:flickr_access_secret].empty?
      puts "Error: not all Flickr api keys present. Please run\n\nrake flickraw:get_flickr_tokens"
      return
    end

    puts "Starting update images"

    images_to_update = Image.published.not_from_hidden_album.readonly(false).
        where('images.uploaded_to_flickr_at < images.updated_at AND images.flickr_photo_id != "" AND images.updated_at > ? ', (3.days.ago))

    if images_to_update.size > 0
      FlickRaw.api_key = SITE[:flickr_api_key]
      FlickRaw.shared_secret = SITE[:flickr_shared_secret]

      flickr.access_token = SITE[:flickr_access_token]
      flickr.access_secret = SITE[:flickr_access_secret]

      login = flickr.test.login

      puts "You are now authenticated as #{login.username}"

      puts "Updating #{images_to_update.size} images ..."

      images_to_update.each do |image|
        puts "Updating image #{image.id}"
        begin
          # Updating tags
          flickr.photos.setTags(:photo_id => image.flickr_photo_id, :tags => image.tags_resolved)

          # Updating title and description
          flickr.photos.setMeta(:photo_id => image.flickr_photo_id, :title => image.title, :description => image.render_data)

          photo_context = flickr.photos.getAllContexts(:photo_id => image.flickr_photo_id)

          update_photoset = false
          current_photo_album = photo_context['set'][0]['title']

          if image.album.title != current_photo_album
            puts "Updating photosets, removing image from other photosets"
            update_photoset = true

            photo_context['set'].each do |set|
              if image.album.title != set['title']
                puts "Remove image #{image.flickr_photo_id} from set \"#{set['title']}\""
                flickr.photosets.removePhoto(:photoset_id => photo_context['set'][0]['id'], :photo_id => image.flickr_photo_id)
              end
            end
          end

          if update_photoset
            puts "Getting list of Flickr photosets (albums)"
            photosets = flickr.photosets.getList

            if photosets.map(&:title).include?(image.album.title)
              # Add
              photoset_id = photosets.select {|p| p['title'] == image.album.title}[0]['id']
              puts "Adding image #{image.flickr_photo_id} to photoset #{photoset_id}"
              flickr.photosets.addPhoto(:photoset_id => photoset_id, :photo_id => image.flickr_photo_id)
            else
              # Create photoset
              puts "Creating photoset '#{image.album.title}'"
              flickr.photosets.create(:title => image.album.title, :description => '', :primary_photo_id => image.flickr_photo_id)
              puts "Image #{image.flickr_photo_id} set as primary in photoset #{image.album.title}"
            end
          end

          # Update image timestamp
          time_now = Time.now
          image.update_attributes({:uploaded_to_flickr_at => time_now, :updated_at => time_now})
        rescue Exception => e
          puts e.message
        end
        puts "Metadata updated for image #{image.id}"
      end
    end
  end
end
