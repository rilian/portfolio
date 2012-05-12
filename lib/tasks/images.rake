namespace :images do
  desc 'Publishes unpublished Image, one at a time'
  task :publish_unpublished => :environment do
    image_to_publish = Image.where('published_at IS NULL').order('created_at DESC').limit(1).first
    if image_to_publish
      image_to_publish.published_at = Time.now
      image_to_publish.save!
      puts "Published image #{image_to_publish.id}"
    end
  end
end