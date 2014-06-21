source 'https://rubygems.org'

# Backend
gem 'rails', '4.1.1'
gem 'sqlite3'
gem 'devise'
gem 'cancan'
gem 'carrierwave'
gem 'mini_magick'
gem "ransack", github: "activerecord-hackery/ransack", branch: "rails-4.1"
gem 'kaminari'
#gem 'rocket_tag', github: 'rilian/rocket_tag', branch: 'feature/rails4-compatibility'
gem 'whenever', require: false
gem 'flickraw'
gem 'disqus'
gem 'nokogiri'

# Frontend
gem 'jquery-rails'
gem 'simple_form'

group :assets do
  gem 'sass-rails', '4.0.3'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
end

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'factory_girl_rails'
  gem 'coveralls', require: false
  gem 'rspec-rails'
  gem 'database_rewinder'
  gem 'shoulda'
end

group :production do
  gem 'unicorn'
  gem 'carrierwave-imageoptimizer'
end
