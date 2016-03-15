#!/bin/sh

modprobe  virtio_rpmsg_bus
modprobe  imx6sx_remoteproc firmware=memf-remote-demo-new.out
modprobe  rpmsg_user_dev_driver

#firmware=nucleus-remote-firmware
#firmware=memf-reremote-demo.out
