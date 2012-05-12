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

    image_to_upload = Image.where('published_at IS NOT NULL').where(:is_uploaded_to_flickr => false).order('published_at DESC').limit(1).first

    if image_to_upload
      FlickRaw.api_key = SITE[:flickr_api_key]
      FlickRaw.shared_secret = SITE[:flickr_shared_secret]

      flickr.access_token = SITE[:flickr_access_token]
      flickr.access_secret = SITE[:flickr_access_secret]

      login = flickr.test.login

      puts "You are now authenticated as #{login.username}"

      puts 'Uploading'
      result = flickr.upload_photo(image_to_upload.asset.path,
                                  :title => image_to_upload.title,
                                  :description => image_to_upload.render_data)
      puts "Result: #{result.inspect}"

      image_to_upload.update_attribute(:is_uploaded_to_flickr, true)
    else
      puts "no images to upload"
    end
  end
end
