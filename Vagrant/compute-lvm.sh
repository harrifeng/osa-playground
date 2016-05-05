apt-get install -y lvm2
parted /dev/sdb mklabel gpt
parted --align optimal /dev/sdb mkpart primary 0% 100%
parted /dev/sdb set 1 lvm on
pvcreate /dev/sdb1
vgcreate vmsvg /dev/sdb1
lvcreate --extents 100%FREE --name vms vmsvg
mkfs.ext4 /dev/mapper/vmsvg-vms
mkdir /vms
echo '/dev/mapper/vmsvg-vms /vms ext4 errors=remount-ro 0 1' >> /etc/fstab
mount -a
