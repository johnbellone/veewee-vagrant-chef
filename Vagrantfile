Vagrant.configure("2") do |config|
  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # Use the most recent version of Chef Solo and install it on this image.
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of. 
  # This is usually a image specifically cooked using Veewee (or Packer)
  # which has the guest additions already installed. Obviously this does
  # not need to be the case - you can build them yourself!
  config.vm.hostname = "ubuntu-demo"
  config.vm.box = 'opscode-ubuntu-12.04'
  config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "33.33.33.10"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 8080 on the guest machine.
  config.vm.network :forwarded_port, guest: 8080, host: 8080

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Use VBoxManage to customize the VM. For example to change memory and
  # the number of CPUs:
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 256]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  # Set some settings for the host->guest SSH connection.
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # Finally setup Chef Solo to provision the virtual machine environment
  # with the necessary tools we need to deploy our application. This
  # mainly boils down to Ruby.
  config.vm.provision :chef_solo do |chef|
    chef.run_list = ['recipe[apt]', 'recipe[ruby_build]', 'recipe[rbenv::system]', 'recipe[rbenv::vagrant]']

    # Install Ruby 1.9.3 and some default gems. We need 'bundler' for our deploys.
    chef.json = {
     :rbenv => {
      :rubies => ['1.9.3-p429'],
      :global => '1.9.3-p429',
      :gems => {
        '1.9.3-p429' => [
          {'name' => 'bundler'},
          {'name' => 'rake'}
        ]
      }
     }
    }
  end
end
