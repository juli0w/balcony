server '191.252.109.24', user: 'deployer', roles: %w{app web db}

set :deploy_user, "deployer"

set :use_sudo, true
set :rvm_type, :system
set :rvm_ruby_version, '2.3.3@mgo'

role :app, %w{deployer@191.252.109.24}
role :web, %w{deployer@191.252.109.24}
role :db,  %w{deployer@191.252.109.24}

set :application, 'balcony'
set :repo_url, 'git@github.com:juli0w/balcony.git'
set :branch, 'master'

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}
