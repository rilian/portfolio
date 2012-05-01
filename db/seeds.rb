# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Album.delete_all
Image.delete_all

User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'

%w(Photo Illustration Collage Art Cooking).each do |title|
  cat = FactoryGirl.create(:album, :title => title)
  2.times do
    FactoryGirl.create(:image, :album => cat)
    FactoryGirl.create(:image_vertical, :album => cat)
  end
end

puts "#{User.all.count} users created"
puts "#{Album.all.count} albums created"
puts "#{Image.all.count} images created"