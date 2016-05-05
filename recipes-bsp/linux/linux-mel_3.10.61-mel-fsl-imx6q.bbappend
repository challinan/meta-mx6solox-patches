# Need to remove CONFIG_CPU_IDLE so the core doesn't go to low 
# power mode during JTAG debug

do_configure_append() {
	bbnote "Squashing CONFIG_CPU_IDLE for proper jtag operation"
	sed -i 's/CONFIG_CPU_IDLE=y/# CONFIG_CPU_IDLE is not set/' .config
}
