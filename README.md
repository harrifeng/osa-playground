# osa-playground
## Overview
Playground to understand and develop OpenStack Ansible.

## Getting Started
### Required Setup
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

**FYI:  `vagrant destroy` can cause the loss of your hard work.  Be cautious where you save configuration files and data that you need to persist.**
