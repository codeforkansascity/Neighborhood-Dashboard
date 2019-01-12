# Developing for Neighborhood Dashboard in a Vagrant Environment

If you want to develop for the Neighborhood Dashboard application in an isolated environment, one option is to use a Vagrant box. Perform these steps before you start on the instructions in the `README.md` file.

### Install Vagrant & Choose a Box

If you don't already have Vagrant installed, you can download it here:

https://www.vagrantup.com/

Next, choose a box that you can use as a starting point. You can browse boxes and find installation instructions for each here:

https://app.vagrantup.com/boxes/search

The box you choose is up to you, but I generally choose a pretty bare bones image as a starting point to build on, such as one of the official Ubuntu boxes:

https://app.vagrantup.com/ubuntu/boxes/bionic64

### Changes to Vagrantfile

There are a few changes you need to make before you start up your Vagrant box with the `vagarant up` command. Do this by adding or updating lines in the `Vagrantfile`, found in the directory where you installed the Vagrant box:

1. **Forward port 3000** - the Ruby on Rails application will be listening for requests on port 3000 on the guest machine. You need to forward that port so you can hit the server in the browser on your host machine. Add the following the line:

    config.vm.network "forwarded_port", guest: 3000, host: 3000

2. **Setup a synced folder** - you'll need to have the code available in a synced folder so it's available on both the host and guest machines. Add the following line (or similar):

    config.vm.synced_folder "./NeighborhoodDashboard", "/NeighborhoodDashboard"

The first parameter is the location on the host machine and is relative to the directory where the box is. The second parameter is the location on the guest box and is an absolute path.

3. **Increase memory** - Make sure your Vagrant box has sufficient memory. I encountered some memory issues with the default 1GB of memory. 4GB seemed to work for me:

    config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
    end

### Clone the Repo, Setup Application

Now you can use `vagrant up` to start the Vagrant box, then `vagrant ssh` to access a shell in the guest machine. From here, follow the instructions in the `README.md` file from within the guest machine to clone the repo and setup the Ruby on Rails application. Be sure to clone the repo into the synced folder that you setup above so it's accessible in both the host and guest machines.

When you run your Rails server, you need to use the following command:

    rails server -b 0.0.0.0
