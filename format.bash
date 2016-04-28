#!/bin/bash

PART=$(sudo kpartx -s -av disk.img)
if [ $? -eq 0 ]; then
  DEV=$(echo $PART | cut -d\  -f3 )
  sudo mkfs.ext2 /dev/mapper/$DEV
  sudo mount -o loop /dev/mapper/$DEV /mnt/
  sudo mkdir /mnt/ppc
  sudo cp incept bootinfo.txt /mnt/ppc/
  sudo umount /mnt
fi
