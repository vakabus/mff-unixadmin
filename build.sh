#!/bin/bash

if test "$NO_CACHE" = "true"; then
	PACSTRAP_ARG=
else
	PACSTRAP_ARG=-c
fi

name=$1

if test -z "$name"; then
	echo "Name server was not provided!"
	exit 1
fi

outdir=_build
packages=$(cat $name/packages.list | tr '\n' ' ')

root=$outdir/$name-root
back_up=../..



mkdir -p $root
echo "Initializing rootfs with packages" 1>&2
pacstrap $PACSTRAP_ARG $root base sudo linux zerotier-one $packages


echo "Copying configuration"
cp -a $name/* $root


echo "Configuring boot"
if test ! -e $root/init; then
	ln -s /lib/systemd/systemd $root/init
fi
chmod +x $root/init


echo "Applying patches to work better as initramdisk"
mv $root/etc/os-release $root/etc/initrd-release

# save name into rootfs for debugging
echo "$name" > $root/name

# changing password for root user and teacher
cat $root/etc/shadow | sed '/^root:.*$/d' > $root/etc/shadow2
echo 'root:$6$qsvN0BqcBPHVAV8b$NDSivlZ4N6NVJqS4UpaGDZbOX6axQFO87.rK1MA1V.iZaYPL7c7JlFUAbw6yXOhzq/tVvzK2TTyJPssy5n1GC1:18203::::::' > $root/etc/shadow
echo 'teacher:$6$qsvN0BqcBPHVAV8b$NDSivlZ4N6NVJqS4UpaGDZbOX6axQFO87.rK1MA1V.iZaYPL7c7JlFUAbw6yXOhzq/tVvzK2TTyJPssy5n1GC1:18203::::::' >> $root/etc/shadow
cat $root/etc/shadow2 >> $root/etc/shadow
rm $root/etc/shadow2

# create teacher user as alias for root
grep root $root/etc/passwd | sed 's/^root/teacher/' >> $root/etc/passwd
mkdir $root/home/teacher

# add trusted-keys from our TLDs
curl -s "https://asch.cz/unix/trusted-una.key" > $root/etc/trusted-una.key

# fixing up permissions
chown -R root:root $root/root
chown -R root:root $root/etc

# extract kernel before cleanup
cp $root/boot/vmlinuz-linux $outdir/kernel.img

# reducing size of the image
rm -rf $root/usr/share/man
rm -rf $root/usr/share/doc
rm -rf $root/usr/share/gtk-doc
rm -rf $root/etc/share/locale
rm -rf $root/boot/*

# create file filled with zeros as a free disk space
dd if=/dev/zero of=$root/freespace bs=1M count=50

echo "Building ramdisk"
cd $root; find -print0  | cpio --null -ov --format=newc 2>/dev/null | gzip > "$back_up/$outdir/$name-rootfs.cpio.gz"; cd $back_up

echo "Cleaning up rootfs dir"
rm -rf $root
