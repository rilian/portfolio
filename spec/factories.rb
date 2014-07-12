# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
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
    sequence(:title) { |n| "Title #{n}" }
    is_published true
  end

  factory :image do
    album
    asset                 File.open("#{Rails.root}/spec/fixtures/file.png")
    sequence(:title)      { |n| "Title #{n}" }
    desc                  { FactoryGirl.generate(:body) }
    place                 'Kiev'
    date                  Date.today
    published_at          Time.now
    flickr_photo_id       '1234567890'
    deviantart_link       'http://deviantart.com/'
    istockphoto_link      'http://istockphoto.com/'
    shutterstock_link     'http://shutterstock.com/'
    is_for_sale           false
  end
end
