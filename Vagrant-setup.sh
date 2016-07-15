#!/bin/bash

# system setup
apt-get update
apt-get install -y git curl htop build-essential

# Install NodeJS 6 via repository
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs

# app setup as user vagrant
# cd /vagrant
# sudo -u vagrant bash -c ""
# su - vagrant -c "cd /vagrant && ./cli.sh build"
#
# cd /vagrant
# ./cli.sh install
# # ./cli.sh build
# # npm start
