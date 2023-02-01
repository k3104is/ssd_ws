#!/bin/bash

# you should execute bellow command.
# `sudo bash ./install_ssd.sh`

set -x

SSD_DEV="/dev/sdb"
MOUNT_POINT="/mnt/ssd"

USERS=(`ls /home`)

# clear ssd
dd if=/dev/zero of=${SSD_DEV}

# create parition
parted -a optimal ${SSD_DEV} -s mklabel msdos \
  -s mkpart primary ext4 2048 100% 
fdisk -l ${SSD_DEV}


mkdir -p ${MOUNT_POINT}
mkfs -t ext4 ${SSD_DEV}1
mount -t ext4 ${SSD_DEV}1 ${MOUNT_POINT}

pushd ${MOUNT_POINT}
for dir in ${USERS[@]}
do
  mkdir ${dir}
  chown -R ${dir}:${dir} ${dir}
done
popd

# config auto
echo "${SSD_DEV}1 ${MOUNT_POINT} auto defaults 0 0" >> /etc/fstab

