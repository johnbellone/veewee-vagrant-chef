# veewee-vagrant-chef/config/deploy.rb
set :application, "veewee-vagrant-chef"
set :repository, '.'
set :deploy_via, :copy
set :copy_exclude, IO.readlines('.deployignore').map(&:chomp)
set :normalize_asset_timestamps, false

# Information about credentials necessary for the *deploy*.
set :user, 'vagrant'
set :group, 'vagrant'
set :default_run_options, {
  :shell => '/bin/bash -l',
  :pty => true
}
set :ssh_options, {
  :forward_agent => true,
  :keys => ['~/.vagrant.d/insecure_private_key']
}

# Modify the deploy directory with proper group.
after 'deploy:setup' do
  run "#{sudo} chgrp -R #{group} #{deploy_to} && #{sudo} chmod -R g+s #{deploy_to}" 
end

require 'bundler/capistrano'

# Cleanup after ourselves because your mother doesn't work here.
after "deploy:restart", "deploy:cleanup"

# Setup all the options for exporting a Upstart configuration with Foreman.
require 'capistrano/foreman'
set :foreman_upstart_path, '/etc/init'

# Actually run the Foreman commands to get an Upstart configuration.
after :deploy, 'foreman:export'
after 'deploy:start', 'foreman:start'
after 'deploy:restart', 'foreman:restart'
after 'deploy:stop', 'foreman:stop'

server '33.33.33.10', :app


