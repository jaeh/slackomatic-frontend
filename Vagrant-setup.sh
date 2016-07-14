#!/bin/bash

# system setup
apt-get update
apt-get install -y git curl htop
apt-get install -y build-essential

# Install NodeJS 6 via repository
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs

# app setup as user vagrant
su - vagrant -c "cd /vagrant && ./cli.sh install"
# su - vagrant -c "cd /vagrant && ./cli.sh build"
#
# cd /vagrant
# ./cli.sh install
# # ./cli.sh build
# # npm start
