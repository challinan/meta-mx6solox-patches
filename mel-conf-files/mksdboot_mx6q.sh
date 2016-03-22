#! /bin/sh
# Script to create SD card for MX6q.
#
# Author: Arun Khandavalli, Sujith Haridasan, Mentor Graphics Inc.

# Licensed under terms of GPLv2
#
# sudo ./mksdboot_mx6q.sh --sdk $PWD/tmp/deploy/images/<machine> --machine mx6-solox --rootfs core-image-sato --device /dev/sde --firmware nucleus-remote-firmware

VERSION="0.1"


: ${MACHINE:="mx6q"}
: ${ROOTFS_IMAGE:="console-image-${MACHINE}.tar.bz2"}
: ${sdkdir:="`pwd`/tmp/deploy/images/${MACHINE}"}
dtb=zImage-imx6sx-sdb-mel-master.dtb

execute ()
{
    $* >/dev/null
    if [ $? -ne 0 ]; then
        echo
        echo "ERROR: executing $*"
        echo
        exit 1
    fi
}

version ()
{
  echo
  echo "`basename $1` version $VERSION"
  echo "Script to create bootable SD card for mx6q-evm"
  echo

  exit 0
}

usage ()
{
  echo "
Usage: `basename $1` <options> [ files for install partition ]

Mandatory options:
  --device              SD block device node (e.g /dev/sdd)
  --sdk                 Where is sdk installed ?
  --rootfs		Which rootfs would you like to install ? [console-image (or) core-image-sato ]
  --machine             Please specify machine name (Supported: sabre-lite, nit6x-lite, nit6x, sabre-sd, sabre-aiquad, sabre-aidual, mx6solox)

Optional options:
  --firmware		Path to the remote firmware image (defaults to sdk directory)
  --version             Print version.
  --help                Print this help message.
"
  exit 1
}

check_if_main_drive ()
{
  mount | grep " on / type " > /dev/null
  if [ "$?" != "0" ]
  then
    echo "-- WARNING: not able to determine current filesystem device"
  else
    main_dev=`mount | grep " on / type " | awk '{print $1}'`
    echo "-- Main device is: $main_dev"
    echo $main_dev | grep "$device" > /dev/null
    [ "$?" = "0" ] && echo "++ ERROR: $device seems to be current main drive ++" && exit 1
  fi

}


# Check if the script was started as root or with sudo
user=`id -u`
[ "$user" != "0" ] && echo "++ Must be root/sudo ++" && exit

FW_IMAGE=""

# Process command line...
while [ $# -gt 0 ]; do
  case $1 in
    --help | -h)
      usage $0
      ;;
    --device) shift; device=$1; shift; ;;
    --sdk) shift; sdkdir=$1; shift; ;;
    --rootfs ) shift; ROOTFS_IMAGE="$1-${MACHINE}.tar.bz2"; shift; ;;
    --machine) shift; machine=$1; shift; ;;
    --firmware) shift; FW_IMAGE=$1; shift; ;;
    --version) version $0;;
    *) copy="$copy $1"; shift; ;;
  esac
done

echo "SDKDIR = $sdkdir"
echo "ROOTFS_IMAGE = $ROOTFS_IMAGE"
echo "machine = $machine"

test -z $sdkdir && usage $0
test -z $device && usage $0
test -z $ROOTFS_IMAGE && usage $0
test -z $machine && usage $0

kernel=
case $machine in
    sabre-lite|nit6x-lite|nit6x|sabre-sd|sabre-aiquad|sabre-aidual)
          fstype_boot=ext2
          fstype_labelopt="-L"
          kernel=uImage
      ;;
    mx6solox|mx6-solox)
          fstype_boot=vfat
          fstype_labelopt="-n"
          kernel=zImage
      ;;
    *)
     echo "Only sabre-lite, nit6x-lite, nit6x, sabre-sd, sabre-aiquad, sabre-aidual, mx6solox"
     exit 1
esac

if [ ! -d $sdkdir ]; then
   echo "ERROR: $sdkdir does not exist"
   exit 1;
fi

if [ ! -b $device ]; then
   echo "ERROR: $device is not a block device file"
   exit 1;
fi

check_if_main_drive

echo "************************************************************"
echo "*         THIS WILL DELETE ALL THE DATA ON $device        *"
echo "*                                                          *"
echo "*         WARNING! Make sure your computer does not go     *"
echo "*                  in to idle mode while this script is    *"
echo "*                  running. The script will complete,      *"
echo "*                  but your SD card may be corrupted.      *"
echo "*                                                          *"
echo "*         Press <ENTER> to confirm....                     *"
echo "************************************************************"
#read junk

for i in `ls -1 $device?*`; do
 echo "unmounting device '$i'"
 umount $i 2>/dev/null
done

execute "dd if=/dev/zero of=$device oflag=sync bs=1M count=1"

cat << END | fdisk $device
n
p
1

+62M
n
p
2


t
1
c
a
1
w
END

# handle various device names.
PARTITION1=${device}1
if [ ! -b ${PARTITION1} ]; then
        PARTITION1=${device}p1
fi

PARTITION2=${device}2
if [ ! -b ${PARTITION2} ]; then
        PARTITION2=${device}p2
fi

# make partitions.
echo "Formatting ${PARTITION1} ..."
if [ -b ${PARTITION1} ]; then
	mkfs.${fstype_boot} ${fstype_labelopt} "boot" ${PARTITION1}
else
	echo "Cant find boot partition in /dev"
fi

echo "Formatting ${PARTITION2} ..."
if [ -b ${PARTITION2} ]; then
	mkfs.ext4 -L "rootfs" ${PARTITION2}
else
	echo "Cant find rootfs partition in /dev"
fi

echo "Copying filesystem on ${PARTITION1},${PARTITION2}"
execute "mkdir -p /tmp/sdk/$$/boot"
execute "mkdir -p /tmp/sdk/$$/rootfs"
execute "mount ${PARTITION1} /tmp/sdk/$$/boot"
execute "mount ${PARTITION2} /tmp/sdk/$$/rootfs"

uboot=
case $machine in                                                                                          
    sabre-lite)                                                                                      
      uboot=u-boot-sabre-lite-mx6q.imx
      dtb=uImage-imx6q-sabrelite.dtb
      execute "cp $sdkdir/$uboot /tmp/sdk/$$/boot/"
      ;;
    nit6x-lite) 
      uboot=u-boot-nitrogen6x-lite.imx
      dtb=uImage-imx6dl-nit6xlite.dtb 
      execute "cp $sdkdir/$uboot /tmp/sdk/$$/boot/"
      ;;
    nit6x)
      uboot=u-boot-nitrogen6xq.imx
      dtb=uImage-imx6q-nitrogen6x.dtb
      execute "cp $sdkdir/$uboot /tmp/sdk/$$/boot/"
      ;;
    sabre-sd)
      uboot=u-boot-sabresd.imx
      dtb=uImage-imx6q-sabresd.dtb
      execute "sudo dd if=$sdkdir/$uboot of=$device bs=512 seek=2"
      ;;
    sabre-aiquad)
      uboot=u-boot-sabre-aiquad-mx6q.imx
      dtb=uImage-imx6q-sabreauto.dtb     
      execute "sudo dd if=$sdkdir/$uboot of=$device bs=512 seek=2"
      ;;
    sabre-aidual)
      uboot=u-boot-sabre-aidual-mx6q.imx   
      dtb=uImage-imx6dl-sabreauto.dtb
      execute "sudo dd if=$sdkdir/$uboot of=$device bs=512 seek=2"
      ;;
    mx6solox|mx6-solox)
      uboot=u-boot-mx6-solox.imx
	  # if dtb is already set (above) don't change it
      dtb=${dtb:=zImage-imx6sx-sdb.dtb}
      execute "sudo dd if=$sdkdir/$uboot of=$device bs=512 seek=2"
    ;;
    *)
     echo "Only sabre-lite, nit6x-lite, nit6x, sabre-sd, sabre-aiquad, sabre-aidual, mx6solox"
esac                                                                                                

KERNEL_DEVICETREE=`echo $dtb | sed "s:.Image-::"`
echo "Copying kernel device tree as $KERNEL_DEVICETREE to boot device"
execute "cp $sdkdir/$kernel /tmp/sdk/$$/boot/"
execute "cp $sdkdir/$dtb /tmp/sdk/$$/boot/${KERNEL_DEVICETREE}"


if [ ! -f $sdkdir/${ROOTFS_IMAGE} ]
then
        ROOTFS_IMAGE=`echo $ROOTFS_IMAGE | sed 's:-${MACHINE}::'`
fi

if [ ! -f $sdkdir/${ROOTFS_IMAGE} ]; then
        echo "ERROR: failed to find rootfs [${ROOTFS_IMAGE}] tar in $sdkdir"
        ROOTFS_IMAGE=
        execute "umount /tmp/sdk/$$/boot"
        execute "umount /tmp/sdk/$$/root"
        exit 1
fi

echo "Extracting filesystem [${ROOTFS_IMAGE}] on ${PARTITION2} ..."
root_fs=`ls -1 $sdkdir/${ROOTFS_IMAGE}`
execute "sudo tar -xvf $root_fs -C /tmp/sdk/$$/rootfs"
if [ "${FW_IMAGE}" ]; then
	echo "Copying [${FW_IMAGE}] to /lib/firmware directory on ${PARTITION2} ..."
	if [ -f $sdkdir/${FW_IMAGE} ]; then
		mkdir -p /tmp/sdk/$$/rootfs/lib/firmware
		cp $sdkdir/${FW_IMAGE} /tmp/sdk/$$/rootfs/lib/firmware/
	elif [ -f ${FW_IMAGE} ]; then
		mkdir -p /tmp/sdk/$$/rootfs/lib/firmware
		cp ${FW_IMAGE} /tmp/sdk/$$/rootfs/lib/firmware/firmware
	else
		echo "ERROR: failed to find firmware [${FW_IMAGE}] or [$sdkdir/${FW_IMAGE}]"
	fi
fi
sync

echo "unmounting ${PARTITION1},${PARTITION2}"
execute "umount /tmp/sdk/$$/boot"
execute "umount /tmp/sdk/$$/rootfs"

execute "rm -rf /tmp/sdk/$$"
echo "completed!"
