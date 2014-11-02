source 'https://rubygems.org'

# Backend
gem 'rails', '4.2.0.beta3'
gem 'pg'
gem 'devise', github: 'plataformatec/devise', branch: 'lm-rails-4-2'
gem 'cancancan'
gem 'whenever', require: false
gem 'carrierwave'
gem 'carrierwave-imageoptimizer'
gem 'mini_magick'
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.2'

# Frontend
gem 'simple_form'
gem 'kaminari'
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'therubyracer'

group :development, :test do
  gem 'byebug'
end

group :development do
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
