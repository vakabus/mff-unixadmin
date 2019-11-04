#!/bin/bash


name=$1

outdir=_build
packages=$(cat $name/packages.list | tr '\n' ' ')

root=$outdir/$name-root
back_up=../..

mkdir -p $root
echo "Initializing rootfs with packages" 1>&2
pacstrap -c $root base linux git $packages


echo "Copying configuration"
cp -a $name/* $root


echo "Configuring boot"
if test ! -e $root/init; then
	ln -s /lib/systemd/systemd $root/init
fi
chmod +x $root/init


echo "Applying patches to work better as initramdisk"
mv $root/etc/os-release $root/initrd-release
rm $root/boot/init*


# changing password for root user
cat $root/etc/shadow | sed '/^root:.*$/d' > $root/etc/shadow2
echo 'root:$6$qsvN0BqcBPHVAV8b$NDSivlZ4N6NVJqS4UpaGDZbOX6axQFO87.rK1MA1V.iZaYPL7c7JlFUAbw6yXOhzq/tVvzK2TTyJPssy5n1GC1:18203::::::' > $root/etc/shadow
cat $root/etc/shadow2 >> $root/etc/shadow
rm $root/etc/shadow2

# fixing up permissions
chown -R root:root $root/root
chown -R root:root $root/etc


echo "Building ramdisk"
cd $root; find -print0 | cpio --null -ov --format=newc | gzip > "$back_up/$outdir/$name-rootfs.cpio.gz"; cd $back_up
echo "extracting kernel"
cp $root/boot/vmlinuz-linux $outdir/$name-kernel.img

echo "Cleaning up rootfs dir"
rm -rf $root

chown -R vasek:vasek $outdir
