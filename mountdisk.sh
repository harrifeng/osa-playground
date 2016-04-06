parted /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary 512 100%
mkfs.ext4 /dev/sdb1
mkdir /data
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /data ext4   noatime,nobarrier   0   0 >> /etc/fstab
mount /data
