# General cleanup of very bad code ;)

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://demo-master-cleanup.patch;striplevel=5"
