# require 'capistrano/rbenv'
# require 'capistrano/bundler'
# require 'capistrano/rails'
#
set :rbenv_ruby, '2.1.2'
set :rbenv_path, '~/.rbenv'
# set :rbenv_ruby_dir, -> { "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}" }
# set :rbenv_map_bins, %w{rake gem bundle ruby rails}
# set :rbenv_roles, :all # default value
#
# set :bundle_binstubs, -> { shared_path.join('bin') }
# set :bundle_gemfile, -> { release_path.join('Gemfile') }
# set :bundle_path, -> { shared_path.join('bundle') }
# set :bundle_without, %w{development test}.join(' ')
# set :bundle_flags, '--deployment --quiet'
# set :bundle_env_variables, {}
#
# set :bundle_bins, %w{gem rake rails}
# set :migration_role, :db

# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'portfolio'
set :repo_url, 'git@github.com:rilian/portfolio.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, 'deploy'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ubuntu/apps/portfolio'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml .env.production}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}

# Default value for default_env is {}
set :default_env, { path: "/home/ubuntu/.rbenv/shims:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# Custom
set :uploads_dir, '/mnt/apps/portfolio/public/uploads'

namespace :nginx do
  desc 'restart nginx'
  %w{start stop restart}.each do |cmd|
    task cmd.to_sym do
      on roles(:app) do
        execute "sudo service nginx #{cmd}"
      end
    end
  end
end

namespace :deploy do
  desc 'link uploads folder'
  task :link_uploads do
    on roles(:web) do
      raise ':uploads_dir is not defined' unless fetch(:uploads_dir)
      execute :mkdir, '-p', fetch(:uploads_dir)
      execute :ln, '-nfs', fetch(:uploads_dir), "#{release_path}/public/uploads"
    end
  end

  desc 'link nginx.conf'
  task :link_nginx do
    on roles(:web) do
      execute :sudo, :ln, '-nfs', "#{release_path}/config/nginx.conf", '/etc/nginx/conf.d/portfolio.conf'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after 'deploy:finished', 'deploy:link_uploads'
  after 'deploy:finished', 'deploy:link_nginx'
  after 'deploy:finished', 'nginx:restart'

end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      execute "cd #{current_path} && sudo /home/ubuntu/.rbenv/shims/bundle exec bin/foreman export upstart /etc/init -f #{current_path}/Procfile -a #{fetch(:application)} -u #{fetch(:user, 'ubuntu')} -l #{shared_path}/log"
    end
  end

  desc "Start the application services"
  task :start do
    on roles(:app) do
      execute "sudo start #{fetch(:application)}"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      execute "sudo stop #{fetch(:application)}"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      execute "sudo start #{fetch(:application)} || sudo restart #{fetch(:application)}"
    end
  end
end
