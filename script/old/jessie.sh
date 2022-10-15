#!/bin/bash
#    ____  _   _            _    _ _____               _    
#   / / / | | | | __ _  ___| | _| |_   _| __ __ _  ___| | __
#  / / /  | |_| |/ _` |/ __| |/ / | | || '__/ _` |/ __| |/ /
#  \ \ \  |  _  | (_| | (__|   <| | | || | | (_| | (__|   < 
#   \_\_\ |_| |_|\__,_|\___|_|\_\ | |_||_|  \__,_|\___|_|\_\
#   "return of dreams come true"|_|                         
# ------------------------------------------------------------
###################################################################
# Default Profile <<Hack|Track GNU/Linux                       
# version           : 2022.1
# Author            : <<Hack|Track GNU/Linux <hacktracklinux@yahoo.com>
# Licenced          : Copyright 2017-2022 GNU GPLv3
# Website           : https://hacktrackgnulinux.github.io/
###################################################################
# Script Arsip Debootstrap Hacktrack
# make folder work
cd $HOME/$(whoami)/
mkdir $HOME/$(whoami)/hacktrack 
cd $HOME/$(whoami)/hacktrack
sudo mkdir -p image/{live,isolinux,.disk}
sudo debootstrap --arch=i386 --variant=minbase jessie $HOME/$(whoami)/hacktrack/chroot http://ftp.us.debian.org/debian/
sudo mount --bind /dev/ ./chroot/dev/
sudo cp /etc/resolv.conf ./chroot/etc/
sudo chroot chroot
export HOME=/root
export LC_ALL=C
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
passwd root
echo "track" > /etc/hostname
cd /etc/apt/
nano sources.list
# Core Kali-Rolling
deb http://ftp.us.debian.org/debian/ jessie main contrib non-free

apt-get update
apt-get install --no-install-recommends linux-image-686 live-boot systemd-sysv network-manager net-tools wireless-tools wpagui xserver-xorg-core xserver-xorg xinit nano
apt-get install mate-core mate-desktop-environment-extra mate-desktop-environment-extras

apt-get clean && apt-get autoremove && rm -rf /tmp/* ~/.bash_history
umount /proc && umount /sys && umount /dev/pts
exit
sudo umount chroot/dev

cd $HOME/$(whoami)/hacktrack/
sudo cp chroot/boot/vmlinuz-* image/live/vmlinuz
sudo cp chroot/boot/initrd.img-* image/live/initrd.lz 
sudo cp /usr/lib/syslinux/isolinux.bin image/isolinux/

cd $HOME/$(whoami)/hacktrack/
# STANDAR
# sudo mksquashfs chroot image/live/filesystem.squashfs
# UNKNOW
# sudo mksquashfs chroot image/live/filesystem.squashfs -e boot
# HIGH COMPRESS
sudo mksquashfs chroot image/live/filesystem.squashfs -b 1048576 -comp xz -Xdict-size 100%

sudo su
sudo chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' > image/live/filesystem.manifest
printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/live/filesystem.size
exit

cd image/
sudo rm MD5SUMS
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee MD5SUMS
cd ..
sudo mkisofs -r -V "hacktrack-2022.1-i386" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../hacktrack-2022.1-i386.iso image
cd .. && sudo chmod 777 hacktrack-2022.1-i386.iso
isohybrid hacktrack-2022.1-i386.iso
md5sum hacktrack-2022.1-i386.iso > hacktrack-2022.1-i386.iso.md5sums
