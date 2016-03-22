#!/bin/sh

echo "Loading virtio_rpmsg_bus"
modprobe virtio_rpmsg_bus
sleep 1

echo "Loading imx6sx_remoteproc"
modprobe imx6sx_remoteproc
sleep 1

echo "Loading rpmsg_user_dev_driver"
modprobe rpmsg_user_dev_driver
