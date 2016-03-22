DESCRIPTION = "Misc helper utils for debug"
LICENSE = "MIT"

# FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "file://kill-x.sh file://startup.sh \
           file://load.sh file://unload.sh \
           file://memf-remote-demo.out"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

do_install() {
    install -d ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/kill-x.sh ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/startup.sh ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/load.sh ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/unload.sh ${D}/${ROOT_HOME}
    install -m 0755 ${WORKDIR}/memf-remote-demo.out ${D}/${ROOT_HOME}
}

FILES_${PN} += "${ROOT_HOME}/kill-x.sh ${ROOT_HOME}/startup.sh ${ROOT_HOME}/load.sh ${ROOT_HOME}/unload.sh ${ROOT_HOME}/memf-remote-demo.out"
