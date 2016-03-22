FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# SRC_URI_append_mx6-solox += " file://fixup-env-for-memf.patch"

EXTRA_OEMAKE += " V=1"
