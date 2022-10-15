#!/bin/bash
#    ____  _   _            _    _ _____               _    
#   / / / | | | | __ _  ___| | _| |_   _| __ __ _  ___| | __
#  / / /  | |_| |/ _` |/ __| |/ / | | || '__/ _` |/ __| |/ /
#  \ \ \  |  _  | (_| | (__|   <| | | || | | (_| | (__|   < 
#   \_\_\ |_| |_|\__,_|\___|_|\_\ | |_||_|  \__,_|\___|_|\_\
#   "return of dreams come true"|_|                         
# ------------------------------------------------------------
###########################################################################               
# Version           : 2022.1
# Author            : HackTrack Team (HackTrack) <team@hacktracklinux.org>
# Licenced          : Copyright 2017-2022 GNU GPLv3
# Website           : https://www.hacktrackgnulinux.org/
###########################################################################
# Script Arsip Debootstrap Hacktrack amd64

cd /home/$(whoami)/
mkdir /home/$(whoami)/hacktrack 
cd /home/$(whoami)/hacktrack
sudo mkdir -p image/{live,isolinux,.disk}
sudo debootstrap --arch=amd64 --variant=minbase bullseye /home/$(whoami)/hacktrack/chroot http://ftp.us.debian.org/debian/
sudo mount --bind /dev/ ./chroot/dev/
sudo cp /etc/resolv.conf ./chroot/etc/
sudo chroot chroot
export HOME=/root
export LC_ALL=C
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
passwd root
echo "hacktrack" > /etc/hostname
cd /etc/skel
mkdir Desktop Documents Downloads Music Pictures Public Templates Videos
cd /etc/apt/
nano sources.list
# Core Bullseye Debian
deb http://ftp.us.debian.org/debian/ bullseye main contrib non-free
deb https://deb.hacktracklinux.org/ return main contrib non-free
deb https://tools.hacktracklinux.org/return return main contrib non-free

# Core System
apt-get update
apt-get install --no-install-recommends linux-image-amd64 live-boot systemd-sysv network-manager net-tools wireless-tools xserver-xorg-core xserver-xorg xinit nano

# Base System
apt-get install mate-core mate-desktop-environment-extra mate-desktop-environment-extras

apt-get clean && apt-get autoremove && rm -rf /tmp/* ~/.bash_history
umount /proc && umount /sys && umount /dev/pts
exit
sudo umount chroot/dev

cd /home/$(whoami)/hacktrack/
sudo cp chroot/boot/vmlinuz-* image/live/vmlinuz
sudo cp chroot/boot/initrd.img-* image/live/initrd.lz 
sudo cp /usr/lib/syslinux/isolinux.bin image/isolinux/

cd /home/$(whoami)/hacktrack/
# STANDAR
sudo mksquashfs chroot image/live/filesystem.squashfs
# UNKNOW
sudo mksquashfs chroot image/live/filesystem.squashfs -e boot
# HIGH COMPRESS
sudo mksquashfs chroot image/live/filesystem.squashfs -b 1048576 -comp xz -Xdict-size 100%

sudo su
sudo chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' > image/live/filesystem.manifest
printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/live/filesystem.size
exit

cd image/
sudo rm md5sums
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sums
cd ..
sudo mkisofs -r -V "hacktrack-2022.1-amd64" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ./hacktrack-2022.1-RC-amd64.iso image
sudo chmod 777 hacktrack-2022.1-RC00-amd64.iso
isohybrid hacktrack-2022.1-RC00-amd64.iso
md5sum hacktrack-2022.1-RC00-amd64.iso > hacktrack-2022.1-RC00-amd64.iso.md5sums
