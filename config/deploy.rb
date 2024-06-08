# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "timetrackr"
set :repo_url, "git@github.com:mkskovalev/timetrackr.git"

set :branch, 'main'

set :deploy_to, "/home/deploy/timetrackr"
set :deploy_user, 'deploy'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/javascript", "storage"

after 'deploy:published', 'sitemap:refresh:no_ping'