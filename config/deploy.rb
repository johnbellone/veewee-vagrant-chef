# veewee-vagrant-chef/config/deploy.rb
set :application, "veewee-vagrant-chef"
set :repository, '.'
set :deploy_via, :copy
set :copy_exclude, IO.readlines('.deployignore').map(&:chomp)
set :normalize_asset_timestamps, false

# Information about credentials necessary for the *deploy*.
set :user, 'vagrant'
set :group, 'vagrant'

# Login shell is required because of the rbenv.sh shim added to /etc/profile.d.
set :default_run_options, {
  :shell => '/bin/bash -l',
  :pty => true
}

# Use the default vagrant key on these boxes.
set :ssh_options, {
  :forward_agent => true,
  :keys => ['~/.vagrant.d/insecure_private_key']
}

# Modify the deploy directory with proper group.
after 'deploy:setup' do
  run "#{sudo} chgrp -R #{group} #{deploy_to} && #{sudo} chmod -R g+s #{deploy_to}" 
end

# Use the packaged Bundler recipe to run install automatically on deploy.
require 'bundler/capistrano'

# Setup all the options for exporting a Upstart configuration with Foreman.
require 'capistrano/foreman'
set :foreman_upstart_path, '/etc/init'

# Actually run the Foreman commands to get an Upstart configuration.
after 'deploy:create_symlink', 'foreman:export'
after 'deploy:start', 'foreman:start'
after 'deploy:restart', 'foreman:restart'
after 'deploy:stop', 'foreman:stop'

# Cleanup after ourselves because your mother doesn't work here.
after 'deploy:restart', "deploy:cleanup"

# The same private address as in the Vagrantfile.
server '33.33.33.10', :app


