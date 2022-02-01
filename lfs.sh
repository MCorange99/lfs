#!/bin/bash

export user=mcorange
export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb

#sudo umount "$LFS"

if ! grep -q "$LFS" /proc/mounts; then
	source setupDisk.sh "$LFS_DISK"
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


cp -rf *.sh packages.csv "$LFS/sources"
cd "$LFS/sources"
export PATH="$LFS/tools/bin:$PATH"

source download.sh
