##################
# make_rootfs.sh #
##################

#!/bin/bash

URL_ROOTFS_TGZ_BASE=http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.3/release/ubuntu-base-18.04.3-base-arm64.tar.gz

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BUILD_DIR=$SOURCE_DIR/build

rm -r $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# download and extract rootfs
wget -O rootfs.tar.gz $URL_ROOTFS_TGZ_BASE
tar -xpf rootfs.tar.gz
rm rootfs.tar.gz

# chroot to rootfs
QEMU_PATH=/usr/bin/qemu-aarch64-static
if [ ! -f "$FILE" ]; then
    apt-get install qemu-user-static
fi
cp $QEMU_PATH $BUILD_DIR/usr/bin/ 

mount /sys $BUILD_DIR/sys -o bind
mount /proc $BUILD_DIR/proc -o bind
mount /dev $BUILD_DIR/dev -o bind

mv $BUILD_DIR/etc/resolv.conf $BUILD_DIR/etc/resolv.conf.saved
cp /etc/resolv.conf $BUILD_DIR/etc

cp $SOURCE_DIR/install.sh $BUILD_DIR/
LC_ALL=C chroot $BUILD_DIR /bin/bash -c ./install.sh
rm $BUILD_DIR/install.sh

umount $BUILD_DIR/sys
umount $BUILD_DIR/proc
umount $BUILD_DIR/dev

mv $BUILD_DIR/etc/resolv.conf.saved $BUILD_DIR/etc/resolv.conf

rm $BUILD_DIR/usr/bin/qemu-aarch64-static
rm -rf $BUILD_DIR/var/lib/apt/lists/*
rm -rf $BUILD_DIR/dev/*
rm -rf $BUILD_DIR/var/log/*
rm -rf $BUILD_DIR/var/tmp/*
rm -rf $BUILD_DIR/var/cache/apt/archives/*.deb
rm -rf $BUILD_DIR/tmp/*