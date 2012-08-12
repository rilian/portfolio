require 'flickraw'
require 'disqus'

namespace :flickraw do

  def check_flickr_api_keys
    if SITE[:flickr_api_key].empty? || SITE[:flickr_shared_secret].empty? ||
        SITE[:flickr_access_token].empty? || SITE[:flickr_access_secret].empty?
      puts "Error: not all Flickr api keys present. Please run\n\nrake flickraw:get_flickr_tokens"
      return false
    end
    true
  end

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
    return unless check_flickr_api_keys

    puts "Starting upload images"

    image_to_upload = Image.published.not_from_hidden_album.readonly(false).
        where('images.uploaded_to_flickr_at IS NULL AND images.created_at < ?', (Time.now - 30.minutes)).last

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
    return unless check_flickr_api_keys

    puts "Starting update images"

    images_to_update = Image.published.not_from_hidden_album.readonly(false).
        where('images.uploaded_to_flickr_at < images.updated_at AND images.flickr_photo_id != "" AND images.updated_at > ? ', (2.days.ago))

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

  desc "Gets latest comments on Flickr images and export to Disqus"
  task :post_comments_to_disqus => :environment do
    return unless check_flickr_api_keys

    puts "Getting list of Disqus threads"

    # there is a limit 100, default 25, and we have to use cursor to get all the available threads
    has_next_cursor = true
    cursor = ''
    disqus_threads_for_images = {}
    disqus_http = Net::HTTP.new('disqus.com', 80)

    while has_next_cursor do
      puts "Getting threads for cursor '#{cursor}'"

      # http://disqus.com/api/docs/threads/list/
      request = Net::HTTP::Get.new("/api/3.0/threads/list.json?" +
                                    "limit=100&"+
                                    "cursor=#{cursor}&"+
                                    "forum=#{SITE[:disqus_shortname]}"+
                                    "&api_secret=#{SITE[:disqus_api_secret]}")
      response = disqus_http.request(request)
      response_json = JSON(response.body)

      if response_json['cursor'].present? && response_json['cursor']['hasNext']
        cursor = response_json['cursor']['next']
        puts "Have next cursor '#{cursor}'"
      else
        has_next_cursor = false
      end

      # disqus_threads_for_images == {:"108"=>"802536169", :"107"=>"802508264", ... }
      response_json['response'].each do |thread|
        disqus_threads_for_images[(thread['identifiers'][0].scan(/(\d+)/).last.first).to_sym] = thread['id']
      end
    end

    puts "Starting update images"

    FlickRaw.api_key = SITE[:flickr_api_key]
    FlickRaw.shared_secret = SITE[:flickr_shared_secret]

    flickr.access_token = SITE[:flickr_access_token]
    flickr.access_secret = SITE[:flickr_access_secret]

    login = flickr.test.login

    puts "You are now authenticated as #{login.username}"

    images = Image.published.not_from_hidden_album.readonly(false).where('images.flickr_photo_id != ""')

    puts "Updating #{images.size} images ..."

    images.each do |image|
      puts "Image ##{image.id}"

      comments = flickr.photos.comments.getList(
        :photo_id => image.flickr_photo_id,
        :min_comment_date => image.flickr_comment_time,
        :max_comment_date => Time.now.to_i
      )

      latest_flickr_comment_time = 0

      if comments.respond_to?(:each)
        comments.each do |comment|
          latest_flickr_comment_time = comment['datecreate']
          thread = disqus_threads_for_images[image.id.to_s.to_sym]
          message = "From Flickr by <b>#{comment['authorname']}</b>:\n---\n#{comment['_content']}\n---\nSee original message here #{comment['permalink']}"

          puts message

          # http://disqus.com/api/docs/posts/create/
          request = Net::HTTP::Post.new("/api/3.0/posts/create.json?" +
                                          "thread=#{thread}&" +
                                          "message=#{CGI.escape(message)}&" +
                                          "access_token=#{SITE[:disqus_access_token]}&" +
                                          "api_key=#{SITE[:disqus_api_key]}"
          )

          response = disqus_http.request(request)
          puts response.inspect
          puts response.body
        end
        image.update_attributes({:flickr_comment_time => latest_flickr_comment_time, :updated_at => image.updated_at})
      else
        puts "No comments yet for image #{image.id}"
      end

      return if image.id < 100 #TODO: remove once real testing done
    end
  end
end
