### Vagrant Approach (development on hold)
**NOTE: Using Vagrant introduced a few challenges that were killing progress toward the goal.  So, the testbed will be simplified to use straight VirtualBox and Ubuntu 14.04.  The Vagrant approach may be revisited and the files in this repository associated with approach will remain but will not be used until the challenges are resolved.**

#### Environment Setup ####

This test bed uses Vagrant and VirtualBox running on an Ubuntu 14.04 host.  The VMs are also Ubuntu 14.04.  At the creation time of this project, Vagrant 1.7.2 was used and VirtualBox 4.3.36r105129.  Newer versions of these should work fine.

Once configured with Vagrant and VirtualBox on your host machine, please get the Ubuntu Vagrant box.

    $ vagrant box add ubuntu/trusty64 

After you have cloned this repository, run...

    $ cd Vagrant
    $ vagrant up
  
**Note: Currently, you will need to select your host's network adapter to be used by the NAT interface for the VMs.  I believe this to be a default configuration by Vagrant and will not be used in the configuration of the OpenStack network.**

You should now have a controller VM and several node VMs running in VirtualBox.

    $ vagrant status
  
From there you can log into any of the VMs using...

    $ vagrant ssh controller1
    $ vagrant ssh compute1
    $ vagrant ssh compute2
    $ vagrant ssh compute3
  
You should also verify that the **data** drive for each VM has been created and mounted.

**FYI:  `vagrant destroy` can cause the loss of your hard work.  Be cautious where you save configuration files and data that you need to persist.**


Since we will be running the deployment from the first node (controller1), run the following script on *controller1*...

    $ vagrant ssh controller1
    $ sudo -i bash
    $ /vagrant/osa-setup.sh

Verify that a public and private key (id_rsa and id_rsa.pub) were created in /root/.ssh.  These are the keys that will be passed around to the other nodes (for convenience).
On controller1...

    $ chmod 600 id_rsa
    $ chmod 600 id_rsa.pub
    $ cp /root/.ssh/id_rsa* /vagrant
    $ cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys


Now, get the prerequisite software on *ALL NODES, including the CONTROLLERS*...

    $ sudo -i bash
    $ /vagrant/vagrant-nodes-setup.sh

Copy the keys to each of the remaining nodes (compute1-3)

    $ vagrant ssh computeX
    $ sudo -i bash
    $ cd .ssh
    $ cp id_rsa* .
    $ cat id_rsa.pub >> authorized_keys

Configure the networking for each of the nodes (controller1, compute1-3).  To do this, we will copy example configuration from the /vagrant directory into a temporary directory in root's home directory (*interfaces.d*).  Then, we will update each bridge configuration to have the correct static IP address.  Finally, we copy these interface configurations to /etc/network/interfaces.d and start the bridges.

    $ mkdir interfaces.d
    $ cd interfaces.d
    $ cp /vagrant/ifcfg-* .

Edit ifcfg-br-host, ifcfg-br-mgmt, ifcfg-br-storage, ifcfg-br-vxlan to have a static IP on the respective subnet

    $ cd /etc/network

Edit the interfaces file to have the line

    source /etc/network/interfaces.d/*

Get the network bridges up
    
    $ cd interfaces.d
    $ cp /root/interfaces.d/ifcfg-* .
    $ ifup br-host; ifup br-mgmt; ifup br-storage; ifup br-vxlan; ifup br-vlan

Verify that the interfaces have the correct IP addresses, can ping reach outside, and have the proper linux bridges

    $ ip a | grep 192
    $ ip a | grep 172
    $ ping google.com
    $ brctl show

      bridge name	bridge id		STP enabled	interfaces
    br-host		8000.080027a2c209	no		eth1
    br-mgmt		8000.080027ee5a00	no		eth2.1000
    br-storage		8000.080027ee5a00	no		eth2.1002
    br-vlan		8000.080027ee5a00	no		eth2
    br-vxlan		8000.080027ee5a00	no		eth2.1001
    
#### Running OpenStack Ansible ####

On the Deployment Host VM (controller1)... 
  1. cp -r openstack_deploy/ /etc/
  2. cd /etc/openstack_deploy/
  3. cp openstack_user_config.yml.example openstack_user_config.yml.  *Note:* an example opestack_user_config.yml file is included in this repository which has values specific to a particular configuration...use carefully!
  4. Generate the passwords and tokens.  *NOTE:* You may want to change the `keystone_auth_admin_password` to something that you can remember or type easily for non-production deployments (which this is).
  
  ```
$ cd /etc/openstack_deploy 
$ /opt/openstack-ansible/scripts/pw-token-gen.py --file user_secrets.yml 
```

  1.  Test syntax of yaml
  
  ```
$ cd /opt/openstack-ansible/playbooks
$ openstack-ansible setup-infrastructure.yml --syntax-check
```
  1.  Setup hosts
  
  ```
$ openstack-ansible setup-hosts.yml
```

  1. Install HAProxy
 
  ```
$ openstack-ansible haproxy-install.yml
```

  1. Setup infrastructure
  
  ```
$ openstack-ansible setup-infrastructure.yml
```

*FAILED*:
TASK: [galera_client | Install pip packages] ********************************** 
failed: [controller1_galera_container-2333ce89] => (item=MySQL-python) => {"attempts": 5, "cmd": "/usr/local/bin/pip install MySQL-python", "failed": true, "item": "MySQL-python"}
msg: Task failed as maximum retries was encountered
failed: [controller1_galera_container-2333ce89] => (item=python-memcached) => {"attempts": 5, "cmd": "/usr/local/bin/pip install python-memcached", "failed": true, "item": "python-memcached"}
msg: Task failed as maximum retries was encountered
failed: [controller1_galera_container-2333ce89] => (item=pycrypto) => {"attempts": 5, "cmd": "/usr/local/bin/pip install pycrypto", "failed": true, "item": "pycrypto"}
msg: Task failed as maximum retries was encountered

FATAL: all hosts have already failed -- aborting


*STATUS:*  Moving on to other projects...the guides that I am following make no mention of configuring repositories which is what I think is holding this up.




#### Extra Notes ####
**I ran into an issue where the linux kernel did not have vhost_net installed or enabled.  Run these commands as root to be sure...**
  1. apt-get update -y
  2. apt-get install linux-image-extra-3.13.0-83-generic
  3. apt-get install linux-image-extra-virtual -y


