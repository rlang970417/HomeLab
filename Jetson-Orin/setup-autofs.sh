#!/bin/bash

# Desc : Shell script for AutoFS setup on Nvidia Jetson Orin Nano

#
# Jetson - Setup LVM on the installed NVME device for the Orin
#
pvcreate /dev/nvme0n1
vgcreate exportvg /dev/nvme0n1
lvcreate --size 100GB --name homelv exportvg
mkfs.ext4 /dev/mapper/exportvg-homelv
mount -t ext4 /dev/mapper/exportvg-homelv /mnt
rsync -a /home/ /mnt/
cd /tmp
mv /home /_home
umount /mnt
mkdir -p /export/home
mount -t ext4 /dev/mapper/exportvg-homelv /export/home

#
# Jetson - AutoFS Setup
#
systemctl stop firewalld
systemctl disable firewalld
# Note : This is the IP and Hostname of my Orin device. Adjust to match your environment.
echo "192.168.1.103		lxjet001.langnau.tst	lxjet001" >> /etc/hosts
sudo apt install y nfs-common nfs-kernel-server autofs
# Note : I'm fine with any host on my network mounting this NFS share. Adjust to match your preferneces.
echo "/export/home 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
systemctl restart nfs-kernel-server
systemctl enable nfs-kernel-server
echo "/home  /etc/auto.home" >> /etc/auto.master
echo "* -fstype=nfs,rw,nosuid,soft  192.168.1.103:/export/home/&" >> /etc/auto.home
systemctl restart autofs
systemctl enable autofs
export MyUUID=$(ls -l /dev/disk/by-uuid/ |grep "dm" |awk '{print $9}')
echo "UUID=${MyUUID}       /export/home      ext4     defaults        0 0"  >> /etc/fstab
systemctl daemon-reload
# Remove the old $HOME directory after performing verifications
if [ -d /_home ]; then   rm -fr /_home; fi
