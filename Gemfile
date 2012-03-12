source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'sqlite3'
gem 'jquery-rails'
gem 'fancybox-rails'

gem 'devise'
gem 'cancan'
gem 'bcrypt-ruby', :require => 'bcrypt'

gem 'ransack'
gem 'kaminari'
gem 'formtastic'

gem 'RedCloth'
gem 'carrierwave'
gem 'mini_magick'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug' unless ENV['TRAVIS']
  gem 'factory_girl_rails'
end

group :test do
  gem 'rspec-rails', "~> 2.6"
  gem 'capybara'
  gem 'selenium-client'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'shoulda'
end

group :production do
  #
end
