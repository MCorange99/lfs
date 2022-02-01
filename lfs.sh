#!/bin/bash
export CFG_FORMAT
export CFG_NODWN
export CFG_NOINSTALL


if [ "$1" == "--format" ] || [ "$2" == "--format" ] || [ "$3" == "--format" ]; then
	export CFG_FORMAT="true"
fi

if [ "$1" == "--no-download" ] || [ "$2" == "--no-download" ] || [ "$3" == "--no-download" ]; then
	export CFG_NODWN="true"
fi

if [ "$1" == "--no-install" ] || [ "$2" == "--no-install" ] || [ "$3" == "--no-install" ]; then
	export CFG_NOINSTALL="true"
fi


export user=mcorange
export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb

#

if ! grep -q "$LFS" /proc/mounts; then
	if [ "$CFG_FORMAT" = "true" ]; then
		echo "SETTINGS: Formatting enabled!"
		source setupDisk.sh "$LFS_DISK"
		
  fi
	sudo mount "${LFS_DISK}2" "$LFS"
	sudo chown -v $user "$LFS"
fi

mkdir -pv $LFS/sources
mkdir -pv $LFS/tools

mkdir -pv $LFS/boot
mkdir -pv $LFS/etc
mkdir -pv $LFS/bin
mkdir -pv $LFS/lib
mkdir -pv $LFS/sbin
mkdir -pv $LFS/usr
mkdir -pv $LFS/var

case $(uname -m) in
  x86_64) mkdir -pv lfs $LFS/lib64 ;;
esac


cp -rf *.sh chapter*/ packages.csv "$LFS/sources"
cd "$LFS/sources"
export PATH="$LFS/tools/bin:$PATH"
if [ ! "$CFG_NODWN" = "true" ]; then
	source download.sh
fi

#binutils gcc  
if [ ! "$CFG_NOINSTALL" = "true" ]; then
	for package in linux glibc libstdc++; do
		source packageInstall.sh 5 $package
		sleep 5
	done
fi