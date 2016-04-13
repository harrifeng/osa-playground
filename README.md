# osa-playground
## Overview
Playground to understand and develop OpenStack Ansible.

## Getting Started
### Required Setup
This test bed uses VirtualBox to run Ubuntu 14.04 VMs to emulate servers in an OpenStack cluster configuration.  The version of VirtualBox used is 4.3.36r105129.  Newer versions of VirtualBox should operate in a similar manner.

The testbed VMs include:
  * Deployment Host - runs OpenStack Ansible
  * Target nodes - 5 VMs on which to deploy OpenStack

### Deployment Host
These instructions are following the steps prescribed by http://docs.openstack.org/developer/openstack-ansible/liberty/install-guide/deploymenthost-add.html
  1.  Install required packages  
    ```
    $ sudo bash
    
    $ apt-get install aptitude build-essential git ntp ntpdate openssh-server python-dev sudo
    ```
  2.  git openstack ansible (decided to try the master branch...could have gone with either kilo or liberty)  
    ```
    $ mkdir /opt/openstack-ansible
    
    $ git clone -b master https://github.com/openstack/openstack-ansible.git /opt/openstack-ansible
    
    $ cd /opt/openstack-ansible
    
    $ scripts/bootstrap-ansible.sh
    ```
  3.  Setup ssh keys  
    1.  Create key using ssh-keygen with no password.  Use osa-key as a name for the key (not id_rsa if running on local machine)
    2.  Push out keys to server vms and deployment vm.  File pushkeys.sh can be an example on doing this simply.
    3.  Test passwordless ssh between deployment machine and nodes.


### Target Nodes



### Vagrant Approach (development on hold)
**NOTE: Using Vagrant introduced a few challenges that were killing progress toward the goal.  So, the testbed will be simplified to use straight VirtualBox and Ubuntu 14.04.  The Vagrant approach may be revisited and the files in this repository associated with approach will remain but will not be used until the challenges are resolved.**

~~This test bed uses Vagrant and VirtualBox running on an Ubuntu 14.04 host.  The VMs are also Ubuntu 14.04.  At the creation time of this project, Vagrant 1.7.2 was used and VirtualBox 4.3.36r105129.  Newer versions of these should work fine.~~

~~Once configured with Vagrant and VirtualBox on your host machine, please get the Ubuntu Vagrant box.~~

~~$ vagrant box add ubuntu/trusty64~~ 

~~After you have cloned this repository, run...~~

~~$ vagrant init~~
~~$ vagrant up~~
  
~~**Note: Currently, you will need to select your host's network adapter to be used by the NAT interface for the VMs.  I believe this to be a default configuration by Vagrant and will not be used in the configuration of the OpenStack network.**~~

~~You should now have a controller VM and several node VMs running in VirtualBox.~~

~~$ vagrant status~~
  
~~From there you can log into any of the VMs using...~~

~~$ vagrant ssh controller~~
~~$ vagrant ssh node1~~
  
~~You should also verify that the **data** drive for each VM has been created and mounted.~~

~~**FYI:  `vagrant destroy` can cause the loss of your hard work.  Be cautious where you save configuration files and data that you need to persist.**~~
