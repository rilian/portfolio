# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Category.delete_all
Image.delete_all

User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'

%w(Photo Illustration Collage Art Cooking).each do |title|
  cat = FactoryGirl.create(:category, :title => title)
  2.times do
    FactoryGirl.create(:image, :category => cat)
    FactoryGirl.create(:image_vertical, :category => cat)
  end
end

puts "#{User.all.count} users created"
puts "#{Category.all.count} categories created"
puts "#{Image.all.count} images created"