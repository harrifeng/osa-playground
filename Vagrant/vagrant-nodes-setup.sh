apt-get update -y
apt-get install bridge-utils debootstrap ifenslave ifenslave-2.6 lsof lvm2 ntp ntpdate openssh-server sudo tcpdump vlan linux-image-extra-virtual -y
modprobe bonding
modprobe 8021q
modprobe vhost_net
echo 'bonding' >> /etc/modules
echo '8021q' >> /etc/modules
echo 'vhost_net' >> /etc/modules
