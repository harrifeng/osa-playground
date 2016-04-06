# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
    config.vm.define "controller" do |controller|
        controller.vm.box = "ubuntu/trusty64"
        controller.vm.hostname = "controller"
        
        controller.vm.network "private_network", ip: "192.168.0.10"
        controller.vm.network "public_network"
    
        controller.vm.provider "virtualbox" do |vb|
            vb.name = "controller"
            vb.memory = "2048"
            vb.cpus = "2"
            file_to_disk = './controller_disk.vdi'
    
            vb.customize ['createhd', '--filename', file_to_disk, '--size', 50 * 1024]
            vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        end
    
        controller.vm.provision "shell", path: "./mountdisk.sh"
    end

    config.vm.define "node1" do |node1|
        node1.vm.box = "ubuntu/trusty64"
        node1.vm.hostname = "node1"
        
        node1.vm.network "private_network", ip: "192.168.0.11"
        node1.vm.network "public_network"
    
        node1.vm.provider "virtualbox" do |vb|
            vb.name = "node1"
            vb.memory = "2048"
            vb.cpus = "2"
            file_to_disk = './node1_disk.vdi'
    
            vb.customize ['createhd', '--filename', file_to_disk, '--size', 50 * 1024]
            vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        end
    
        node1.vm.provision "shell", path: "./mountdisk.sh"
    end
end
