# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :title do |n|
    "Title #{n}"
  end

  sequence :email do |n|
    "email.#{n+1}@example.local"
  end

  sequence :body do |n|
    "Lorem Ipsum #{n} is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took."
  end

  factory :user do
    email                 FactoryGirl.generate(:email)
    password              'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end

  factory :album do
    title  { FactoryGirl.generate(:title) }
    images []
  end

  factory :image do
    album
    asset       File.open("#{Rails.root}/spec/fixtures/file.jpg")
    title       { FactoryGirl.generate(:title) }
    desc        { FactoryGirl.generate(:body) }
    place       'Kiev'
    date        Date.today
    is_vertical false
    factory :image_vertical do
      asset       File.open("#{Rails.root}/spec/fixtures/file_vertical.png")
      is_vertical true
    end
  end
end