FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_mx6-solox += " file://fixup-env-for-memf.patch"

# Uncomment the following line to debug u-boot build issues
# EXTRA_OEMAKE += " V=1"
