# Veewee, Vagrant and Chef (Deployment testing)
[![Build Status](https://travis-ci.org/scaledc/veewee-vagrant-chef.png)](https://travis-ci.org/scaledc/veewee-vagrant-chef)

The [original content][13] from this was developed from my [blog][14].

This is the [example project][12] for the [Scale DC][11] presentation on deployment
testing with [Veewee][10], [Vagrant][4] and [Chef][1]. It provides a relatively
simple example of deploying a small Ruby web application to a local virtual
machine guest for testing.

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

## Setup

After you have all of the requirements installed and have checked out the
repository locally you have a few preparation steps. [Vagrant][4] has the
capability of adding plugins to it. We use this feature to properly utilize
the [Berkshelf][3] gem and install our [Chef][1] cookbooks automatically.

In addition to above since our base boxes that are built with [Veewee][10]
actually do not include [Chef][1] we need to use a plugin for this as well.
What this means is that we'll always have the latest version of Chef to
provision our machines with.

        $ vagrant plugin install vagrant-berkshelf
        $ vagrant plugin install vagrant-omnibus

## Cooking a base box

This part of the project is generally overlooked as most people just grab a
already cooked set of base boxes from GitHub. I tend to use [Opscode][1] own
[bento box project][9] which is agnostic from the [Chef][1] software package
provisioner. Basically this is just a vanilla Linux box ready to rock and
roll with [Vagrant][4].

But if you want to cook your own machine image [Veewee][10] is an excellent
gem to do so. And the best part about it is that the [bento box project][9]
uses [Veewee][10] to define its boxes. Therefore you use this as a basis for
any tweaks you need to do!

An example of the above, once you have the repository checked out:

        $ bundle install --binstubs
        $ bin/veewee vbox build 'ubuntu-12.04' --nogui --force
        $ bin/veewee vbox export 'ubuntu-12.04'
        $ vagrant box add 'opscode-ubuntu-12.04' 'ubuntu-12.04.box'

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

Congratulations! You have a running guest virtual machine with Ubuntu Linux!

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

If everything goes as expected you should be prompted with a 'Hello World'
message which is delivered from the small web server that is being run inside of
the guest virtual machine.

## License

Copyright (C) 2013, John Bellone <john.bellone.jr@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[1]: http://opscode.com/chef
[2]: https://rubygems.org
[3]: http://berkshelf.com
[4]: http://vagrantup.com
[5]: http://gembundler.com
[6]: http://www.ruby-lang.org
[7]: http://virtualbox.org
[8]: https://github.com/capistrano/capistrano
[9]: https://github.com/opscode/bento
[10]: https://github.com/jedi4ever/veewee
[11]: http://meetup.com/Scale-DC
[12]: https://github.com/scaledc/veewee-vagrant-chef
[13]: http://www.thoughtlessbanter.com/blog/2013-04-27-from-vewee-to-vagrant-then-chef/
[14]: http://www.thoughtlessbanter.com/
