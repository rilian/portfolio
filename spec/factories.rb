FactoryGirl.define do
  sequence :email do |n|
    "email.#{n+1}@example.local"
  end

  sequence :username do |n|
    "bob_jack_#{n}"
  end

  sequence :title do |n|
    "Title_#{n}"
  end

  sequence :body do |n|
    "Body_#{n}"
  end

  factory :user do
    username   { Factory.next(:username) }
    email      { Factory.next(:email) }
  end

  factory :category do
    title { Factory.next(:title) }
    posts { [Factory(:post)] }

    factory :category_without_posts do
      posts { [] }
    end
  end

  factory :post do
    title { Factory.next(:title) }
    body { Factory.next(:body) }
    is_published false

    images { [Factory(:image)] }

    factory :post_without_images do
      images { [] }
    end
  end

  factory :image do
    asset File.open("#{Rails.root}/spec/support/file.jpg")
  end
end