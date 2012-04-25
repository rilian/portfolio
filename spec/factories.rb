# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :title do |n|
    "Title_#{n}"
  end

  sequence :email do |n|
    "email.#{n+1}@example.local"
  end

  sequence :username do |n|
    "bob_#{n}"
  end

  sequence :body do |n|
    "Lorem Ipsum #{n} is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  end

  factory :user do
    name                  FactoryGirl.generate(:username)
    email                 FactoryGirl.generate(:email)
    password              'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end

  factory :category do
    title  { FactoryGirl.generate(:title) }
    images []
  end

  factory :image do
    category
    asset       File.open("#{Rails.root}/spec/support/file.jpg")
    title       { FactoryGirl.generate(:title) }
    desc        { FactoryGirl.generate(:body) }
    is_vertical false
  end
end