# config valid only for Capistrano 3.1
lock '3.2.1'

set :stage, :production
set :application, 'papergest'
set :repo_url, 'https://github.com/biospank/paperclip-site.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/webapps/papergest'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#set :linked_files, %w{config/database.yml.example config/application.yml.example}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo /etc/init.d/apache2 restart"
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Symlink the shared database configuration file'
  task :symlink_db_config do
    run "ln -s #{shared_path}/database.yml #{release_path}/config/"
  end

  desc 'Symlink the shared env configuration file'
  task :symlink_env_config do
    run "ln -s #{shared_path}/application.yml #{release_path}/config/"
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

end
