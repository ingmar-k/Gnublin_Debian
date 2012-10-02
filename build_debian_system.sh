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

check_priviliges # check if the script was run with root priviliges

if [ -z "$1" ] # if started without parameters, just run the full program, as specified in 'general_settings.sh'
then
	prep_output
	build_rootfs
	if [ "${create_disk}" = "yes" ]
	then
		create_sd_card
	fi
	regular_cleanup
	
elif [ "$1" = "build" ] && [ -z "$2" ]  # case of just wanting to build a compressed rootfs archive
then
	param_1="build"
	prep_output
	build_rootfs
	regular_cleanup
	
elif [ "$1" = "install" ] && [ ! -z "$2" ]
then
	prep_output
	fn_my_echo "Running the script in install-only mode!
Just creating a complete, fully bootable sd-card."
	param_1="install"
	if [ "$2" = "default" ]
	then
		fn_my_echo "Using the default rootfs-package settings defined in 'general_settings.sh'."
		rootfs_package_path=${default_rootfs_package_path}
		rootfs_package_name=${default_rootfs_package_name}
	else 
		rootfs_package_path=${2%/*}
		rootfs_package_name=${2##*/}
	fi
	get_n_check_file "${rootfs_package_path}" "${rootfs_package_name}" "rootfs_package" "${output_dir}"
	if [ "${rootfs_package_name:(-8)}" = ".tar.bz2" ]
	then
		tar_format="bz2"
		output_filename="${rootfs_package_name%.tar.bz2}"
	elif [ "${rootfs_package_name:(-7)}" = ".tar.gz" ]
	then
		tar_format="gz"
		output_filename="${rootfs_package_name%.tar.gz}"
	else
		fn_my_echo "The variable rootfs_package_name seems to point to a file that is neither a '.tar.bz2' nor a '.tar.gz' package.
Please check! Exiting now."
		exit 1
	fi
	create_sd_card
	regular_cleanup
	
elif [ "$1" = "install" ] && [ -z "$2" ]
then
	echo "You seem to have called the script with the 'install' parameter.
This requires the location of the compressed rootfs archive as second parameter.
Please rerun the script accordingly.
For example:
sudo ./build_debian_system.sh install 'http://www.hs-augsburg.de/~ingmar_k/gnublin/rootfs_packages/8MB/debian_rootfs_gnublin_1349121567.tar.bz2'
"
	exit 2
else
	echo "'$0' was called with parameter '$1', which does not seem to be a correct parameter.
	
Correct parameters are:
-----------------------
build : If you only want to build a compressed rootfs archive (for example for later use), according to the setting in 'general_settings.sh'.
install 'archivename': if you only want to create a bootable SD-card with an already existing rootfs-package (tar.bz2 or tar.gz compressed archive).
-----------------------
Besides that you can also run '$0' without any parameters, for the full functionality, according to the settings in 'general_settings'.
Exiting now!"
	exit 3
fi


exit 0
