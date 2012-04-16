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
    "Lorem Ipsum #{n} is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  end

  factory :user do
    username   { FactoryGirl.generate(:username) }
    email      { FactoryGirl.generate(:email) }
  end

  factory :category do
    title { FactoryGirl.generate(:title) }
    posts { [FactoryGirl.create(:post, :category => FactoryGirl.create(:category_without_posts))] }

    factory :category_without_posts do
      posts { [] }
    end
  end

  factory :post do
    category { FactoryGirl.create(:category_without_posts) }
    title { FactoryGirl.generate(:title) }
    body { "#{FactoryGirl.generate(:body)} #{Post::DELIMITER} #{FactoryGirl.generate(:body)}" }
    is_published false

    images { [FactoryGirl.create(:image)] }

    factory :post_without_images do
      images { [] }
    end
  end

  factory :image do
    asset File.open("#{Rails.root}/spec/support/file.jpg")
  end
end