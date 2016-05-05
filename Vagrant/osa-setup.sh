apt-get update -y
apt-get install aptitude build-essential git ntp ntpdate openssh-server python-dev sudo libffi-dev libssl-dev -y
mkdir /opt/openstack-ansible
git clone -b 12.0.11 https://github.com/openstack/openstack-ansible.git /opt/openstack-ansible
cd /opt/openstack-ansible
scripts/bootstrap-ansible.sh
