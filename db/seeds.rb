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

user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
puts "New user created #{user.name}"

# Categories
5.times do
  cat = FactoryGirl.create(:category)
  FactoryGirl.create(:image, :category => cat, :is_vertical => true)
  FactoryGirl.create(:image, :category => cat, :is_vertical => false)
  FactoryGirl.create(:image, :category => cat, :is_vertical => true)
  puts cat.inspect
end
puts "#{Category.all.count} categories created"