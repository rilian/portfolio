Welcome to Portfolio
--------------------

Portfolio is a web-application based on Rails 4.x framework that allows you create portfolio with images

Key features:

* Upload artworks and show them in Gallery or Album
* Organize photos in Projects, connecting a topic or event
* Watermarks, Tags, Search, Contacts page, Localization
* Useful admin UI

Build Status [![TravisCI](https://api.travis-ci.org/rilian/portfolio.png?branch=master)](https://travis-ci.org/rilian/portfolio) [![Code Climate](https://codeclimate.com/github/rilian/portfolio.png)](https://codeclimate.com/github/rilian/portfolio) [![Coverage Status](https://coveralls.io/repos/rilian/portfolio/badge.png?branch=master)](https://coveralls.io/r/rilian/portfolio?branch=master) [![Dependency Status](https://gemnasium.com/rilian/portfolio.png)](https://gemnasium.com/rilian/portfolio)

Getting Started
--------------------

Make sure following software is installed:

`brew install optipng jpegoptim imagemagick`

Clone project repo

`git clone https://github.com/rilian/portfolio.git`

Migrate and seed database:

`cd portfolio && rake db:migrate && rake db:seed`

Start the web server

`rails s`

Go to http://localhost:3000

Deploy
--------------------

Modify seeded user account and password

Update settings -> 'production' in database or login and update on site

Deploy with capistrano

`cap deploy:config`
`cap deploy`

If you need to run remotely rake task, use

`cap invoke COMMAND='cd PATH_TO_APPLICATION && bundle exec rake RAILS_ENV=production images:recreate_versions'`
`cap invoke COMMAND='cd /home/username/apps/portfolio/current && bundle exec rake RAILS_ENV=production images:publish_unpublished'`

Contributing
--------------------

I encourage you to test and use the software, send your pull-requests with improvements and suggest cool features!

License
--------------------

Portfolio is provided as is, without any responsibility
