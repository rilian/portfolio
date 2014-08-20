source 'https://rubygems.org'

# Backend
gem 'rails', '4.1.5'
gem 'pg'
gem 'devise'
gem 'cancancan'
gem 'carrierwave'
gem 'mini_magick'
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
gem 'whenever', require: false
gem 'nokogiri'

# Frontend
gem 'jquery-rails'
gem 'simple_form'
gem 'kaminari'

group :assets do
  gem 'sass-rails', '4.0.3'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
end

group :development do
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
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
  gem 'foreman'
  gem 'unicorn'
  gem 'carrierwave-imageoptimizer'
end
