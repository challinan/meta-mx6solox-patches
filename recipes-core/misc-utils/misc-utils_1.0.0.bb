DESCRIPTION = "Misc helper utils for debug"
LICENSE = "MIT"

# FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "file://kill-x.sh file://startup.sh"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

do_install() {
    install -d ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/kill-x.sh ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/startup.sh ${D}/${ROOT_HOME}
}

FILES_${PN} += "${ROOT_HOME}/kill-x.sh ${ROOT_HOME}/startup.sh"
