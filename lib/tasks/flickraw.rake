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

  desc 'Communicates with Flickr API to get OAuth access tokens for app'
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
      auth_url = flickr.get_authorize_url(token['oauth_token'], perms: 'delete')

      puts "Open this url in your process to complete the authication process : #{auth_url}"
      puts "Confirm access for the app"
      puts "run in console: \n\nrake flickraw:get_flickr_tokens oauth_token=#{token['oauth_token']} oauth_token_secret=#{token['oauth_token_secret']} verify="
    end
  end

  desc "Uploads published Images to Flickr"
  task :upload_images => :environment do
    return unless check_flickr_api_keys

    puts 'Starting upload images'

    image_to_upload = Image.published.not_from_hidden_collection.readonly(false).
      where("(images.flickr_photo_id = ? OR images.flickr_photo_id IS NULL) AND images.created_at < ?", '', (Time.now - 30.minutes))

    puts "Total images to upload: #{image_to_upload.all.map(&:id).inspect}"

    image_to_upload = image_to_upload.last

    puts "Will upload #{image_to_upload.inspect}"

    if image_to_upload
      FlickRaw.api_key = SITE[:flickr_api_key]
      FlickRaw.shared_secret = SITE[:flickr_shared_secret]

      flickr.access_token = SITE[:flickr_access_token]
      flickr.access_secret = SITE[:flickr_access_secret]

      login = flickr.test.login

      puts "You are now authenticated as #{login.username}"

      puts 'Uploading ...'
      flickr_photo_id = flickr.upload_photo(image_to_upload.asset.big.path,
                                  title: image_to_upload.title,
                                  description: image_to_upload.render_data)
      puts "Image uploaded id = #{flickr_photo_id}"
      puts 'Updating tags'

      flickr.photos.addTags(photo_id: flickr_photo_id, tags: image_to_upload.tags_resolved)
      puts 'Tags updated'

      puts "Getting list of Flickr photosets (albums)"
      photosets = flickr.photosets.getList

      if photosets.map(&:title).include?(image_to_upload.collection.title)
        # Add
        photoset_id = photosets.select {|p| p['title'] == image_to_upload.collection.title}[0]['id']
        puts "Adding image #{flickr_photo_id} to photoset #{photoset_id}"
        flickr.photosets.addPhoto(photoset_id: photoset_id, photo_id: flickr_photo_id)
      else
        # Create photoset
        puts "Creating photoset '#{image_to_upload.collection.title}'"
        flickr.photosets.create(title: image_to_upload.collection.title, description: '', primary_photo_id: flickr_photo_id)
        puts "Image #{flickr_photo_id} set as primary in photoset #{image_to_upload.collection.title}"
      end

      time_now = Time.now
      image_to_upload.update_attributes({flickr_photo_id: flickr_photo_id, updated_at: time_now})
    else
      puts 'No images to upload'
    end
  end

  desc 'Updates metadata on Flickr images, which are changed in the last week'
  task :update_images_data => :environment do
    return unless check_flickr_api_keys

    puts 'Starting update images'

    images_to_update = Image.published.not_from_hidden_collection.readonly(false).
        where('images.flickr_photo_id != "" AND images.updated_at > ? ', (7.days.ago))

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
          flickr.photos.setTags(photo_id: image.flickr_photo_id, tags: image.tags_resolved)

          # Updating title and description
          flickr.photos.setMeta(photo_id: image.flickr_photo_id, title: image.title, description: image.render_data)

          photo_context = flickr.photos.getAllContexts(photo_id: image.flickr_photo_id)

          update_photoset = false
          current_photo_album = photo_context['set'][0]['title']

          if image.collection.title != current_photo_album
            puts 'Updating photosets, removing image from other photosets'
            update_photoset = true

            photo_context['set'].each do |set|
              if image.collection.title != set['title']
                puts "Remove image #{image.flickr_photo_id} from set \"#{set['title']}\""
                flickr.photosets.removePhoto(photoset_id: photo_context['set'][0]['id'], photo_id: image.flickr_photo_id)
              end
            end
          end

          if update_photoset
            puts "Getting list of Flickr photosets (albums)"
            photosets = flickr.photosets.getList

            if photosets.map(&:title).include?(image.collection.title)
              # Add
              photoset_id = photosets.select {|p| p['title'] == image.collection.title}[0]['id']
              puts "Adding image #{image.flickr_photo_id} to photoset #{photoset_id}"
              flickr.photosets.addPhoto(photoset_id: photoset_id, photo_id: image.flickr_photo_id)
            else
              # Create photoset
              puts "Creating photoset '#{image.collection.title}'"
              flickr.photosets.create(title: image.collection.title, description: '', primary_photo_id: image.flickr_photo_id)
              puts "Image #{image.flickr_photo_id} set as primary in photoset #{image.collection.title}"
            end
          end

          # Update image timestamp
          time_now = Time.now
          image.update_attributes({updated_at: time_now})
        rescue Exception => e
          puts e.message
        end
        puts "Metadata updated for image #{image.id}"
      end
    end
  end

  desc 'Removes photos on Flickr which are deleted on the site'
  task :remove_deleted_on_site => :environment do
    return unless check_flickr_api_keys

    puts 'Removing images temporary disabled'
    return true

    puts 'Starting remove images'

    FlickRaw.api_key = SITE[:flickr_api_key]
    FlickRaw.shared_secret = SITE[:flickr_shared_secret]

    flickr.access_token = SITE[:flickr_access_token]
    flickr.access_secret = SITE[:flickr_access_secret]

    login = flickr.test.login

    puts "You are now authenticated as #{login.username}"

    #TODO: this loads only last 100 photos, and effectively disables images starting from 101
    #      add loading of other images from flickr
    all_flickr_image_ids = flickr.photos.search(user_id: SITE[:flickr_user_id]).map(&:id)
    all_existing_image_ids = Image.all.map(&:flickr_photo_id).reject {|i| i.empty? }
    flickr_image_ids_to_delete = all_flickr_image_ids - all_existing_image_ids
    flickr_image_ids_to_delete.each do |image_id|
      puts "deleting #{image_id}"
      flickr.photos.delete(photo_id: image_id)
    end

    not_existing_flickr_images = all_existing_image_ids - all_flickr_image_ids
    if not_existing_flickr_images.size > 0
      time_now = Time.now
      Image.where("flickr_photo_id IN (?)", not_existing_flickr_images).each do |image|
        puts "cleanup flickr_photo_id #{image.flickr_photo_id} on image ##{image.id}"
        image.update_attributes({flickr_photo_id: '', updated_at: time_now})
      end
    end
  end

  desc 'Gets latest comments on Flickr images and export to Disqus'
  task :post_comments_to_disqus => :environment do
    return unless check_flickr_api_keys

    #TODO: check why this task does not work. Probably Disqus token expired
    puts 'Getting list of Disqus threads'

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

      # disqus_threads_for_images == {:'108'=>'802536169', :'107'=>'802508264', ... }
      response_json['response'].each do |thread|
        disqus_threads_for_images[(thread['identifiers'][0].scan(/(\d+)/).last.first).to_sym] = thread['id']
      end
    end

    puts 'Starting update images'

    FlickRaw.api_key = SITE[:flickr_api_key]
    FlickRaw.shared_secret = SITE[:flickr_shared_secret]

    flickr.access_token = SITE[:flickr_access_token]
    flickr.access_secret = SITE[:flickr_access_secret]

    login = flickr.test.login

    puts "You are now authenticated as #{login.username}"

    images = Image.published.not_from_hidden_collection.readonly(false).where('images.flickr_photo_id != ""')

    puts "Updating #{images.size} images ..."

    images.each do |image|
      puts "Image ##{image.id}"

      comments = []
      begin
        comments = flickr.photos.comments.getList(
          photo_id: image.flickr_photo_id,
          min_comment_date: image.flickr_comment_time + 1,
          max_comment_date: Time.now.to_i,
          # Faves loading disabled cause this effectively disables the :min_comment_date option.
          #:include_faves => true
        )
      rescue Exception => e
        puts e.message
      end

      latest_flickr_comment_time = 0

      if comments.respond_to?(:each) && comments.size > 0
        comments.each do |comment|
          thread = disqus_threads_for_images[image.id.to_s.to_sym]
          is_type_known = false
          if comment['type'] == 'comment'
            latest_flickr_comment_time = [latest_flickr_comment_time.to_i, comment['datecreate'].to_i].max
            message = "From Flickr by <b>#{comment['authorname']}</b>:\n---\n#{comment['_content']}\n---\nSee original message here #{comment['permalink']}"
            is_type_known = true
          elsif comment['type'] == 'faves'
            latest_flickr_comment_time = [latest_flickr_comment_time.to_i, comment['faves']['person'][0]['favedate'].to_i].max
            message = "On Flickr <b>#{comment['faves']['person'][0]['username']}</b> added your picture to <b>favorites</b>"
            is_type_known = true
          end

          if is_type_known
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
          else
            puts 'type was not known'
          end
        end
        puts "image flickr_comment_time WAS #{image.flickr_comment_time}"
        image.update_attributes({flickr_comment_time: latest_flickr_comment_time.to_i, updated_at: image.updated_at})
        image.save
        puts image.errors
        puts "image flickr_comment_time NOW #{image.flickr_comment_time}"
      else
        puts "No new comments yet after #{Time.at(image.flickr_comment_time).strftime("%d %b %Y")} for image #{image.id}"
      end
    end
  end
end
