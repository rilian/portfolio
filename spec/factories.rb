FactoryGirl.define do
  sequence :title do |n|
    "Title_#{n}"
  end

  sequence :body do |n|
    "Body_#{n}"
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