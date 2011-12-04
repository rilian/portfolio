# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all
Post.delete_all

puts Category.create(:title => 'Illustrations').inspect
puts Category.create(:title => 'Photo').inspect
puts Category.create(:title => 'Decor').inspect
puts Category.create(:title => 'Teaching').inspect
puts Category.create(:title => 'Cooking').inspect
puts Category.create(:title => 'Blog').inspect

Category.all.each do |category|
  (5+rand(15)).times do
    puts Post.create(:title => Faker::Lorem.words(5).join(' '), :body => Faker::Lorem.paragraphs(4).join(' <br/>'), :category => category, :is_published => true).inspect
  end
end
