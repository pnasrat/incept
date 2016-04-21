#!/bin/bash

sudo kpartx -av disk.img
sudo mkfs.ext2 /dev/mapper/loop1p1
sudo mount -o loop /dev/mapper/loop1p1 /mnt/
sudo mkdir /mnt/ppc
sudo cp incept bootinfo.txt /mnt/ppc/
sudo umount /mnt
