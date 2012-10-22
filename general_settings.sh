#!/bin/bash
# Author: Ingmar Klein (ingmar.klein@hs-augsburg.de)
# Additional part of the main script 'build_debian_system.sh', that contains all the general settings
# Created in scope of the "Embedded Linux" lecture, held by Professor Hubert Hoegl, at the University of Applied Sciences Augsburg, 2012


# This program (including documentation) is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License version 3 (GPLv3; http://www.gnu.org/licenses/gpl-3.0.html )
# for more details.


###################################
##### GENERAL BUILD SETTINGS: #####
###################################

### These settings MUST be checked ###

host_os="Debian" # Debian or Ubuntu (YOU NEED TO EDIT THIS!)
nameserver_addr="192.168.2.1" # "141.82.48.1" (YOU NEED TO EDIT THIS!)
output_dir_base="/home/celemine1gig/gnublin_debian_build" # where to put the files in general (YOU NEED TO EDIT THIS!)
use_udev="no" # for the 8MB Gnublin, say "no" here, whereas the 32MB version of Gnublin is fine running udev (YOU NEED TO EDIT THIS!)
bootloader_bin_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/bootloader" # where to get the bootloader (belongs to the setting below and DOES NOT NEED to be edited)
bootloader_bin_name="apex_8MB.bin" # bootloader binary: 'apex_8MB.bin' for the 8MB Gnublin and 'apex_32MB.bin' for the 32MB version! (YOU NEED TO EDIT THIS!)


### These settings are for experienced users ###

debian_mirror_url="http://ftp.de.debian.org/debian/" # mirror for debian

debian_target_version="squeeze" # The version of debian that you want to build (ATM, 'squeeze', 'wheezy' and 'sid' are supported)


qemu_kernel_pkg_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/kernels/3.3.0" # where to get the qemu kernel

qemu_kernel_pkg_name="kernel_3.3.0-gnublin-qemu-1.0_1348953287.tar.bz2" # qemu kernel file name

std_kernel_pkg_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/kernels/3.3.0" # where to get the standard kernel

std_kernel_pkg_name="kernel_3.3.0-gnublin-debian-tiny-1.0_1349121494.tar.bz2" # standard kernel file name

tar_format="bz2" # bz2(=bzip2) or gz(=gzip)

output_dir="${output_dir_base}/build_`date +%s`" # Subdirectory for each build-run, ending with the unified Unix-Timestamp (seconds passed since Jan 01 1970)

work_image_size_MB=1024 # size of the temporary image file, in which the installation process is carried out

output_filename="debian_rootfs_gnublin_`date +%s`" # base name of the output file (compressed rootfs)


apt_prerequisites_debian="debootstrap binfmt-support qemu-user-static qemu qemu-kvm qemu-system parted" # packages needed for the build process on debian

apt_prerequisites_ubuntu="debootstrap binfmt-support qemu qemu-system qemu-kvm qemu-kvm-extras-static parted" # packages needed for the build process on ubuntu


base_packages_no_udev="apt-utils dialog locales makedev mingetty"

base_packages_with_udev="apt-utils dialog locales udev mingetty"


clean_tmp_files="yes" # delete the temporary files, when the build process is done?

create_disk="no" # create a bootable SD-card after building the rootfs?



####################################
##### SPECIFIC BUILD SETTINGS: #####
####################################


### Additional Software ###

additional_packages="file manpages man-db i2c-tools module-init-tools dhcp3-client netbase ifupdown iproute iputils-ping net-tools wget vim nano hdparm rsync bzip2 p7zip unrar unzip zip p7zip-full screen less usbutils psmisc strace info ethtool wireless-tools iw wpasupplicant python whois time ruby procps perl parted ftp gettext firmware-linux-free firmware-linux-nonfree firmware-realtek firmware-ralink firmware-linux firmware-brcm80211 firmware-atheros rcconf lrzsz libpam-modules" # IMPORTANT NOTE: All package names need to be seperated by a single space


### Settings for compressed SWAP space in RAM ### 

use_ramzswap="no" # Kernel 2.6.xx only!!! Set if you want to use a compressed SWAP space in RAM and your Kernel version is 2.6.xx (can potentionally improve performance)

ramzswap_kernel_module_name="ramzswap" # name of the ramzswap kernel module (could have a different name on newer kernel versions)

ramzswap_size_kb="3072" # size of the ramzswap device in KB (!!!)


use_zram="yes" # Kernel 3.x.x only!!! set if you want to use a compressed SWAP space in RAM and your Kernel version is 3.x.x (can potentionally improve performance)

zram_kernel_module_name="zram" # name of the ramzswap kernel module (could have a different name on newer kernel versions)

zram_size_B="2097152" # size of the ramzswap device in Byte (!!!)


vm_swappiness="100" # Setting for general kernel RAM swappiness: With RAMzswap and low RAM, a high number (like 100) could be good. Default in Linux mostly is 60.


### Settings for a RTC ###

i2c_hwclock="no" # say "yes" here, if you connected a RTC to your gnublin board, otherwise say "no"

i2c_hwclock_name="ds1307" # name of the hardware RTC (if one is connected)

i2c_hwclock_addr="0x68" # hardware address of the RTC (if one is connected)

rtc_kernel_module_name="rtc-ds1307" # kernel module name of the hardware RTC (if one is connected)


### Udev setting ###

udev_tmpfs_size="3M" # default setting in udev is "10M", which is wasting RAM on the Gnublin



####################################
##### "INSTALL ONLY" SETTINGS: #####
####################################

default_rootfs_package_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/rootfs_packages/8MB" # where to get the compressed rootfs archive

default_rootfs_package_name="debian_rootfs_gnublin_1349121567.tar.bz2" # filename of the rootfs-archive



