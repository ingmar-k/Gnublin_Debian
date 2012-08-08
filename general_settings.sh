#!/bin/bash
# Author: Ingmar Klein (ingmar.klein@hs-augsburg.de)
# Additional part of the main script 'build_debian_system.sh', that contains all the general settings
# Created in scope of the "Embedded Linux" lecture, held by Professor Hubert Hoegl, at the University of Applied Sciences Augsburg, 2012


# This program (including documentation) is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License version 3 (GPLv3; http://www.gnu.org/licenses/gpl-3.0.html ) for more details.


#############################
##### GENERAL SETTINGS: #####
#############################

host_os="Ubuntu" # Debian or Ubuntu (YOU NEED TO EDIT THIS!)

debian_mirror_url="http://ftp.uk.debian.org/emdebian/grip" # mirror for debian

debian_target_version="squeeze" # The version of debian that you want to build (ATM, 'squeeze', 'wheezy' and 'sid' are supported)

#kernel_pkg_path="${HOME}/gnublin/built_kernels" # http: ... for getting the kernel package online, or a local directory for getting it off your hdd

qemu_kernel_pkg_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/kernels" # where to get the qemu kernel

std_kernel_pkg_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/kernels" # where to get the standard kernel

qemu_kernel_pkg_name="kernel_2.6.33-gnublin-qemu-1.2_1335647673.tar.bz2" # qemu kernel file name

std_kernel_pkg_name="kernel_2.6.33-gnublin-1.17-server_1338645868.tar.bz2" # standard kernel file name

bootloader_bin_path="http://www.hs-augsburg.de/~ingmar_k/gnublin/bootloader" # where to get the bootloader

bootloader_bin_name="apex.bin" # bootloader binary

tar_format="gz" # bz2(=bzip2) or gz(=gzip)

output_dir_base="/home/celemine1gig/gnublin_debian_build" # where to put the files in general (YOU NEED TO EDIT THIS!)

output_dir="${output_dir_base}/build_`date +%s`" # Subdirectory for each build-run, ending with the unified Unix-Timestamp (seconds passed since Jan 01 1970)

work_image_size_MB=1024 # size of the temporary image file, in which the installation process is carried out

output_filename="emdebian_rootfs_gnublin" # base name of the output file (compressed rootfs)

apt_prerequisites_debian="debootstrap binfmt-support qemu-user-static qemu qemu-kvm qemu-system parted" # packages needed for the build process on debian

apt_prerequisites_ubuntu="debootstrap binfmt-support qemu qemu-system qemu-kvm qemu-kvm-extras-static parted" # packages needed for the build process on ubuntu

clean_tmp_files="yes" # delete the temporary files, when the build process is done?

create_disk="yes" # create a bootable SD-card after building the rootfs?



###################################
##### CONFIGURATION SETTINGS: #####
###################################

nameserver_addr="192.168.2.1" # "141.82.48.1" (YOU NEED TO EDIT THIS!)

use_ramzswap="yes" # set if you want to use a compressed SWAP space in RAM (can potentionally improve performance)

ramzswap_size_kb="3072" # size of the ramzswap device in KB

ramzswap_kernel_module_name="ramzswap" # name of the ramzswap kernel module (could have a different name on newer kernel versions)

vm_swappiness="100" # Setting for general kernel RAM swappiness: With RAMzswap and low RAM, a high number (like 100) could be good. Default in Linux mostly is 60.

i2c_hwclock="no" # say "yes" here, if you connected a RTC to your gnublin board, otherwise say "no"

i2c_hwclock_name="ds1307" # name of the hardware RTC (if one is connected)

i2c_hwclock_addr="0x68" # hardware address of the RTC (if one is connected)

rtc_kernel_module_name="rtc-ds1307" # kernel module name of the hardware RTC (if one is connected)

additional_packages="makedev module-init-tools vim nano hdparm lrzsz bzip2 unzip zip screen less usbutils psmisc strace info python whois time ruby procps perl parted build-essential bison flex autoconf automake gcc libc6 cpp curl fakeroot dhcp3-client netbase ifupdown iproute iputils-ping wget net-tools ftp ethtool wireless-tools gettext git subversion lm-sensors libnss-mdns libpam-modules nscd ssh rsync rsyslog"
