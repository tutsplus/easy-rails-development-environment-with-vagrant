# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # This line has been updated to point to the "bento/ubuntu-14.04" box instead of "chef/ubuntu-14.04"
  config.vm.box = "bento/ubuntu-14.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # Install curl and PostgreSQL
    sudo apt-get update
    sudo apt-get install -y curl postgresql-common postgresql-9.3 libpq-dev
    # Create the vagrant db user
    sudo su postgres -c "createuser vagrant -s"
    # Install RVM, Ruby 2.2 and Bundler
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    gpg --list-keys D39DC0E3 > /dev/null
    if [[ $? != 0 ]]; then curl -sSL https://rvm.io/mpapis.asc | gpg --import - ; fi
    curl -sSL https://get.rvm.io | bash -s stable
    source /home/vagrant/.profile
    rvm install 2.2
    gem install bundler --no-ri --no-rdoc
    # Compile and install Redis
    if [ ! -s "redis-stable.tar.gz" ]; then
      curl http://download.redis.io/redis-stable.tar.gz -o redis-stable.tar.gz
      tar xzf redis-stable.tar.gz
      cd redis-stable
      make
      sudo make install
      # Create folders, copy configuration file and init script
      sudo mkdir -p /var/redis/6379 /etc/redis
      sudo cp utils/redis_init_script /etc/init.d/redis_6379
      sudo update-rc.d redis_6379 defaults
      sudo cp redis.conf /etc/redis/6379.conf
      # Edit the default configuration file
      sudo sed -i 's/daemonize no/daemonize yes/g' /etc/redis/6379.conf
      sudo sed -i 's/redis.pid/redis_6379.pid/g' /etc/redis/6379.conf
      sudo sed -i 's/# bind 127.0.0.1/bind 127.0.0.1/g' /etc/redis/6379.conf
      sudo sed -i 's/logfile ""/logfile \/var\/log\/redis_6379.log/g' /etc/redis/6379.conf
      sudo sed -i 's/dir .\//dir \/var\/redis\/6379/g' /etc/redis/6379.conf
      # Start Redis
      sudo service redis_6379 start
      # Cleanup
      cd ..
      sudo rm -rf redis-stable
    fi
    # Install bundled gems and create database
    cd /vagrant
    bundle
    rake db:create db:migrate
    # Create app init scripts with Foreman
    rvmsudo foreman export upstart /etc/init -a rails -u vagrant
    sudo service rails start
  SHELL
end
