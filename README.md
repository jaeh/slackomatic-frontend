# slackomatic frontend

## What does this app do?
This nodejs application serves the frontend for the slackomatic api.


# New Setup


## Prerequisites

Install these on your dev machine:

1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](http://sourabhbajaj.com/mac-setup/Vagrant/README.html)

Run the app in a virtual machine with `vagrant up`.

The current project directory is mapped into the VM as `/vagrant`.

You can log into the VM wih `vagrant ssh`.

    $ vagrant ssh
    vagrant$ cd /vagrant
    vagrant$ ./cli.sh build
    vagrant$ npm start
    # or
    vagrant$ node dist/server.js 1337



Then visit http://10.10.10.10:1337


# Old Setup

!!! Assumes that the production app root is in /home/pi/nodejs!!!
the git clone instructions below will fail if this directory does not exist

one index.html, a slackomatic.appcache file, the favicon.ico and two images for
the shutdown warning and the cleanup warning.

The AppCache allows this site to work even if the server goes down.

```bash
#clone git repository
git clone https://github.com/metalab/slackomatic-frontend /home/pi/nodejs
cd /home/pi/nodejs
```

```bash
#INSTALL: used once before building for the very first time:
npm run setup
or
./cli.sh install
```

```bash
#BUILD: adds local changes to dist directory
./cli.sh build
```

```bash
#BUILD && RUN DEV ENV: builds local deps to dist and runs dist/server.js
npm start
```

```bash
#UPLOAD: push to production (when slackomatic is at 10.20.30.90)
npm run upload
```

```bash
#To start on boot in /etc/inittab on raspbian
#with the source in /home/pi/nodejs:
/home/pi/nodejs/run.sh
```
