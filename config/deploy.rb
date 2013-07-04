# veewee-vagrant-chef/config/deploy.rb
set :application, "veewee-vagrant-chef"
set :repository,  "."

# Information about credentials necessary for the *deploy*.
set :deploy_to, "/var/www/#{application}"
set :user, 'deployer'

# Cleanup after ourselves because your mother doesn't work here.
after "deploy:restart", "deploy:cleanup"

# Setup all the options for exporting a Upstart configuration with Foreman.
require 'capistrano/foreman'
set :foreman_sudo, 'sudo'
set :foreman_upstart_path, '/etc/init'
set :foreman_options, {
 app: application,
 log: File.join(shared_path, 'log'),
 user: 'webuser'
}


