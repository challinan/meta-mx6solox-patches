#!/bin/sh

modprobe -r rpmsg_user_dev_driver
modprobe -r imx6sx_remoteproc
modprobe -r virtio_rpmsg_bus
