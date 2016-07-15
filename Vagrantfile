Vagrant.configure("2") do |config|
  # Base Image: CentOS 7.0 x86_64
  config.vm.box = "debian/wheezy64"

  # Setup the ip-addresses and port bindings
  config.vm.network :private_network, ip: "10.0.0.10"

  # VirtualBox Settings: Increase to 512MB Memory
  config.vm.provider :virtualbox do |vm|

    # via https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck
    host = RbConfig::CONFIG['host_os']

    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 2
      mem = 1024
    end

    vm.customize ["modifyvm", :id, "--memory", mem]
    vm.customize ["modifyvm", :id, "--cpus", cpus]
    vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  # Use Vagrant's default insecure key (~/.vagrant.d/insecure_private_key)
  config.ssh.insert_key = false

  # Map project directory using NFS (http://docs-v1.vagrantup.com/v1/docs/nfs.html)
  # Speedup nfs watching: https://www.jverdeyen.be/vagrant/speedup-vagrant-nfs/ (however we don't use fsc as it required an extra dependency)
  # https://blog.inovex.de/doh-my-vagrant-nfs-is-slow/
  # Does not support Windows!
  config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_udp: false, nfs_version: 3

  # Provision with Ansible
  config.vm.provision "shell", path: "Vagrant-setup.sh"
end
