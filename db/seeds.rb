User.delete_all
Collection.delete_all
Image.delete_all

User.create!(email: 'user@example.com', password: 'please', password_confirmation: 'please')

%w(Photo Illustration Collage Art).each do |title|
  FactoryGirl.create(:album, title: title)
end

puts "#{User.all.count} users created"
puts "#{Album.all.count} albums created"
puts "#{Image.all.count} images created"
