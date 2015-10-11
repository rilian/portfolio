# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'portfolio'
set :repo_url, 'git@github.com:rilian/portfolio.git'
set :deploy_to, '/home/ubuntu/apps/portfolio'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :default_env, { path: '/home/ubuntu/.rbenv/shims:$PATH'}
set :keep_releases, 5

# Custom
set :linked_files, %w{config/database.yml config/secrets.yml .env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}
set :branch, 'master'
set :uploads_dir, '/mnt/apps/portfolio/public/uploads'
set :rbenv_ruby, '2.2.2'
set :rbenv_path, '~/.rbenv'

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

  desc 'link watermark file'
  task :link_watermark do
    on roles(:web) do
      execute :ln, '-nfs', "#{shared_path}/config/watermark.png", "#{release_path}/config/watermark.png"
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
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, :rake, 'tmp:clear'
      end
    end

    invoke 'foreman:restart'
  end

  after :publishing, :restart

  after 'deploy:finished', 'deploy:link_uploads'
  after 'deploy:finished', 'deploy:link_watermark'
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

  desc 'Start the application services'
  task :start do
    on roles(:app) do
      execute "sudo start #{fetch(:application)}"
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles(:app) do
      execute "sudo stop #{fetch(:application)}"
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles(:app) do
      execute "sudo start #{fetch(:application)} || sudo restart #{fetch(:application)}"
    end
  end
end
