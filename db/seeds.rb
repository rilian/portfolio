Setting.delete_all
User.delete_all
Album.delete_all
Project.delete_all
Image.delete_all

Setting.create!
Setting.create!(env: 'test')
Setting.create!(env: 'production')

User.create!(email: 'user@example.com', password: 'please', password_confirmation: 'please')

%w(Photo Illustration Collage Art).each do |title|
  FactoryGirl.create(:album, title: title)
end

project = Project.create!(title: 'Story', description: 'text', info: 'short text', is_published: true)

photo = Photo.new(asset: File.new(File.join(Rails.root, 'spec/fixtures/file.jpg')))
photo.owner_id, photo.owner_type = project.id, 'Project'
photo.save!

puts "#{User.all.count} users created"
puts "#{Album.all.count} albums created"
puts "#{Image.all.count} images created"
puts "#{Project.all.count} projects created"
puts "#{Photo.all.count} photos created"
puts "#{Setting.all.count} settings created"
