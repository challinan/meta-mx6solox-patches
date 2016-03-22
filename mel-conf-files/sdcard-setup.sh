#!/bin/sh
#
# Wrapper script for mksdboot_mx6q to create sdcard for SoloX uAMP Patient Monitor Demo


#echo "Calling mksdboot_mx6q with options --device $1 --machine mx6solox --sdk $PWD  --rootfs core-image-sato --firmware nucleus-remote-firmware"
#MACHINE=mx6solox ./mksdboot_mx6q.sh --device $1 --machine mx6solox --sdk $PWD  --rootfs core-image-sato --firmware nucleus-remote-firmware

sudo MACHINE=mx6-solox ./mksdboot_mx6q.sh --device /dev/sde --machine mx6-solox --sdk /scratch/working/birch/build-mx6solox-memf-new/tmp/deploy/images/mx6-solox --rootfs core-image-sato --firmware memf-remote-demo.out
