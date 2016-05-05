apt-get install -y lvm2
parted /dev/sdb mklabel gpt
parted --align optimal /dev/sdb mkpart primary 0% 100%
parted /dev/sdb set 1 lvm on
pvcreate --metadatasize 2048 /dev/sdb1
vgcreate cinder-volumes /dev/sdb1
