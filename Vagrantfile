Vagrant.configure("2") do |config|
    config.vm.box = "debian/stretch64"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
    #Workaround to fix an OS X specific issue
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'" 
    config.vm.network "public_network"
    #Provision all utilities
    config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.provision :shell, path: "route.sh", run: "always"
  end