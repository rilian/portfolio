source 'https://rubygems.org'

# Backend
gem 'rails', '4.2.0'
gem 'pg'
gem 'devise', github: 'plataformatec/devise', branch: 'lm-rails-4-2'
gem 'cancancan'
gem 'whenever', require: false
gem 'carrierwave'
gem 'carrierwave-imageoptimizer'
gem 'mini_magick'
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.2'
gem 'dotenv-rails', '2.0.1'

# Frontend
gem 'simple_form'
gem 'kaminari'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'therubyracer'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'capistrano', '3.2.1'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'quiet_assets'
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
end
