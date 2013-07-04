# Veewee, Vagrant and Chef (Deployment testing)

## Requirements

I tried to keep the requirements to run this project as basic as possible. Most
of the actual system dependencies developers will already have installed. Since
this talk is focusing on building virtual machines you're going to need the
following software installing, links provided:

* [VirtualBox 4.2][7]
* [Vagrant 1.2.2][4]
* [Ruby 1.9.3][6]
* [Bundler 1.3][5]

Note that for the most part newer versions of this software does not matter.
The recipes will likely all work as expected unless, obviously, there is some
change that requires some tweaking. I'll try and keep everything running like
butter.

## Cooking a base box

This part of the project is generally overlooked as most people just grab a
already cooked set of base boxes from GitHub. I tend to use [Opscode][1] own
[bento box project][9] which is agnostic from the provisioner.

But if you want to cook your own machine image [Veewee][10] is an excellent
gem to do so.

## Building the virtual machine

The goal of this project is to illustrate how easy it is to do basic deployment
testing for web application developement. Since I am more familiar with managing
Ruby applications we are going to use the tools of the trade.

Using a few commands you can get the stack ready for deployment. Let's first get
all of our [Chef][1] cookbooks necessary for provisioning. For this we are using
a [RubyGem][2] called [Berkshelf][3] with a plugin for [Vagrant][4] that manages
injecting the paths where these cookbooks are on disk.

To get all of the dependencies ready:

        $ bundle install --binstubs
        $ bin/berks install

Now that all of the gems and cookbooks are downloaded you can finally start up
the virtual machine using [Vagrant][4]. This is a very simple syntax on the
command line, it was meant to be simple, and you really don't need to do much
after this:

        $ vagrant up

Congratulations! You have a running virtual machine.

## Deploying the application

Since I am more familiar with [Capistrano][8] that's what I will use to setup
the deployment of the [Ruby][2] application. The framework and the setup is out
of the scope of this discussion. All of these are well documented online and you
can search the gems if necessary.

What you need to know is that you can use the following command to get the web
application up and running:

        $ bin/cap deploy:setup deploy:check deploy

After the completion of this the virtual machine has been provisioned, and the
application was deployed (and started). Because the [Vagrant][4] file explicitly
specifies port forwarding the application is available on *port 8080* from the
host machine. It is actually running on the standard HTTP port 80 in the guest
operating system.

[1]: https://opscode.com/chef
[2]: https://rubygems.org
[3]: https://berkshelf.com
[4]: https://vagrantup.com
[5]: https://bundler.com
[6]: https://ruby-lang.org
[7]:
