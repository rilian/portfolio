namespace :images do
  desc 'Publishes unpublished Image, one at a time'
  task :publish_unpublished => :environment do
    image_to_publish = Image.where('published_at IS NULL').order('created_at ASC').limit(1).first
    if image_to_publish
      image_to_publish.published_at = Time.now
      image_to_publish.save!
      puts "Published image #{image_to_publish.id}"
    end
  end

  desc 'Recreate asset versions on all Images'
  task :recreate_versions => :environment do
    Image.all.each do |image|
      image.asset.recreate_versions!
      updated_at = image.updated_at
      image.update_attributes({:image_width => image.image_width, :image_height => image.image_height, :updated_at => updated_at})
      puts "Recreated asset versions for Image##{image.id}"
    end
  end
end