set :application, 'portfolio'
set :repository,  'https://github.com/rilian/portfolio.git'

set :rails_env, 'production'
default_environment["RAILS_ENV"] = 'production'
set :normalize_asset_timestamps, false

set :scm, :git

set :production_server, 'naru.ihdev.net'
role :web, production_server
role :app, production_server
role :db,  production_server, :primary => true

# target
set :deploy_to, '/home/rilian/apps/portfolio'
set :svc_dir,   '/home/rilian/service'

set :user,     'rilian'
set :group,    'rilian'
set :use_sudo, false

# use bundler
require 'bundler/capistrano'

# use rvm
# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
after 'deploy', 'rvm:trust_rvmrc'
after 'deploy:finalize_update', 'deploy:config'

# forward ssh auth
ssh_options[:forward_agent] = true

set :unicorn_pid, '/tmp/unicorn-irene-rilian-portfolio.pid'

namespace :deploy do
  desc "Deploy production configs"
  task :config do
    run <<-CMD
      mkdir -p #{shared_path}/uploads &&
      ln -sf #{shared_path}/uploads #{latest_release}/public/uploads &&
      mkdir -p #{shared_path}/database &&
      ln -sf #{shared_path}/database #{latest_release}/db/shared
      mkdir -p #{shared_path}/config &&
      ln -sf #{shared_path}/config/site.yml #{latest_release}/config/site.yml
    CMD
  end

  desc "Deploy site config"
  task :site_config do
    SITE = YAML.load_file("./config/site.yml")['production']

    run <<-CMD
      mkdir -p #{shared_path}/config &&
      touch #{shared_path}/config/site.yml
    CMD

    result_hash = {'production' => SITE}
    puts YAML.dump(result_hash)
    put YAML.dump(result_hash), "#{shared_path}/config/site.yml"

    run <<-CMD
      ln -sf #{shared_path}/config/site.yml #{latest_release}/config/site.yml
    CMD
  end

  #desc "Zero-downtime restart of Unicorn"
  #task :restart, :except => { :no_release => true } do
  #  run "kill -s USR2 `cat /tmp/unicorn-tapwatch.pid`"
  #end
  #
  #desc "Start unicorn"
  #task :start, :except => { :no_release => true } do
  #  run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  #end
  #
  #desc "Stop unicorn"
  #task :stop, :except => { :no_release => true } do
  #  run "kill -s QUIT `cat /tmp/unicorn-tapwatch.pid`"
  #end

  desc "Down-up restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    run "kill -s HUP `cat #{unicorn_pid}`"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
end

after 'deploy:update_code', 'deploy:migrate'
