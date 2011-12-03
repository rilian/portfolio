# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all
Post.delete_all

puts Category.create(:title => 'Design notes').inspect
puts Category.create(:title => 'Interiors').inspect
puts Category.create(:title => 'Graphic').inspect
puts Category.create(:title => 'Illustrations').inspect

puts Post.create({:title => 'Hello world!', :body => 'Lorem ipsum dolores', :category => Category.find_by_title('Design notes')}, :is_published => true).inspect
puts Post.create({:title => 'Second chapter', :body => 'blah blarg bllahf aa', :category => Category.find_by_title('Design notes'), :is_published => true}).inspect
puts Post.create({:title => 'How to draw with pen!', :body => 'Pax vobiscum lorem ipsum dolores', :category => Category.find_by_title('Graphic'), :is_published => true}).inspect
puts Post.create({:title => 'Third info', :body => 'omm amm blah blarg bllahf dd', :category => Category.find_by_title('Interiors'), :is_published => true}).inspect
puts Post.create({:title => 'Paintings around', :body => 'Amnyan ipsum dolores', :category => Category.find_by_title('Illustrations'), :is_published => true}).inspect
puts Post.create({:title => 'Some design secrets!', :body => 'hrum hrum blah blarg bllahf', :category => Category.find_by_title('Interiors'), :is_published => true}).inspect