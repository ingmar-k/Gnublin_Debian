#!/bin/bash
# Bash script that creates a Debian rootfs or even a complete bootable SD-Card for the Embedded Projects Gnublin board
# Should run on current Debian or Ubuntu versions
# Author: Ingmar Klein (ingmar.klein@hs-augsburg.de)
# Created in scope of the "Embedded Linux" lecture, held by Professor Hubert Hoegl, at the University of Applied Sciences Augsburg, 2012


# This program (including documentation) is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License version 3 (GPLv3; http://www.gnu.org/licenses/gpl-3.0.html ) for more details.

trap int_cleanup INT
source general_settings.sh # Including settings through an additional file
source build_functions.sh # functions called by this main build script

#########################
###### Main script ######
#########################


case "$1" in

"build")  echo "Building a rootfs image and saving it into a single compressed archive."
    parameter_1="$1"
    ;;
"install")  echo  "Installing the contents of a given rootfs-archive onto a bootable SD-card."
    parameter_1="$1"
    ;;
*)if [ -z "$1" ]
  then
	echo "No option passed to '$0'. Standard mode, according to 'general_settings' file."
  else
	echo "'$0' was called with parameter '$1', which does not seem to be a correct parameter.
	
Correct parameters are:
-----------------------
build : If you only want to build a compressed rootfs archive (for example for later use).
install : if you only want to create a bootable SD-card with an already existing rootfs-package.
-----------------------
Besides that you can also run '$0' without any parameters, for the full functionality, according to the settings in 'general_settings'.
Exiting now!"
	exit 64
  fi
   ;;
esac



### Preparation ###

check_priviliges # check if the script was run with root priviliges

mkdir -p ${output_dir} # main directory for the build process
if [ "$?" = "0" ]
then
	echo "Output directory '${output_dir}' successfully created."
else
	echo "ERROR while trying to create the output directory '${output_dir}'. Exiting now!"
	exit 1
fi


mkdir ${output_dir}/tmp # subdirectory for all downloaded or local temporary files
if [ "$?" = "0" ]
then
	echo "Subfolder 'tmp' of output directory '${output_dir}' successfully created."
else
	echo "ERROR while trying to create the 'tmp' subfolder '${output_dir}/tmp'. Exiting now!"
	exit 2
fi


### Rootfs Creation ###

if [ "$parameter_1" = "build" -o -z "$parameter_1" ]  && [ ! "$paramter_1" = "install" ]
then
	check_n_install_prerequisites # see if all needed packages are installed and if the versions are sufficient

	create_n_mount_temp_image_file # create the image file that is then used for the rootfs

	do_debootstrap # run debootstrap (first and second stage)

	disable_mnt_tmpfs # disable all entries in /etc/init.d trying to mount temporary filesystems (tmpfs), in order to save precious RAM

	do_post_debootstrap_config # do some further system configuration

	compress_debian_rootfs # compress the resulting rootfs
fi


### SD-Card Creation ###
if [ "$parameter_1" = "install" ] || [ -z "$paramter_1" -a "${create_disk}" = "yes" ]
then
	if [ "$parameter_1" = "install" ]
	then
		get_n_check_file "${rootfs_package_path}" "${rootfs_package_name}" "rootfs_package"
		${output_dir}="${output_dir}/tmp"
		if [ "${rootfs_package_name:(-8)}" = ".tar.bz2" ]
		then
			${output_filename}="${rootfs_package_name%.tar.bz2}"
		elif [ "${rootfs_package_name:(-7)}" = ".tar.gz" ]
		then
			${output_filename}="${rootfs_package_name%.tar.gz}"
		else
			fn_my_echo "The variable rootfs_package_name seems to point to a file that is neither a '.tar.bz2' nor a '.tar.gz' package.
Please check! Exiting now."
			exit 66
		fi
	fi
	partition_n_format_disk # SD-card: make partitions and format
	finalize_disk # copy the bootloader, rootfs and kernel to the SD-card
fi

exit 0
