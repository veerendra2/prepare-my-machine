# Author: Veerendra K
# Description: Spawns VMs for testing

### BOXES LIST ###
#
# ubuntu/bionic64
# centos/7
# minimal/trusty64
# alpine/alpine64

### MODIFY SCRIPT BELOW ACCORDING TO DISTRO ###

NODES_COUNT = 1
RAM_MB = 1024
CORE_COUNT = 2
BOX = "ubuntu/focal64"


Vagrant.configure("2") do |config|

  (1..NODES_COUNT).each do |i|
    config.vm.define "1matrix#{i}" do |server|
      server.vm.box = BOX
      server.vm.hostname = "1matrix#{i}"

      server.vm.provider "virtualbox" do |v|
        v.name = "1matrix#{i}"
        v.memory = RAM_MB
        v.cpus = CORE_COUNT
      end

      # server.vm.network :private_network, ip: "192.168.56.101"
      # server.vm.network :forwarded_port, guest: 22, host: 10122
      # server.vm.synced_folder "../data", "/vagrant_data"

      config.vm.synced_folder ".", "/vagrant"
      server.vm.provision "shell", path: "init_my_machine.sh"
    end
  end
end
