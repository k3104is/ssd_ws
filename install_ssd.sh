#!/bin/bash

set -x

SSD_DEV="/dev/sdb"
MOUNT_POINT="/mnt/ssd"

USERS=`ls /home`

# clear ssd
dd if=/dev/zero of=${SSD_DEV}

# create parition
parted -a optimal ${SSD_DEV} -s mklabel msdos \
  -s mkpart primary ext4 
fdisk -l ${SSD_DEV}


mkdir -p ${MOUNT_POINT}
mount -t ext4 ${SSD_DEV}1 ${MOUNT_POINT}
pushd ${MOUNT_POINT}
for dir in ${USERS[@]}
do
  mkdir ${dir}
  chown ${dir}:${dir} ${dir}
popd
