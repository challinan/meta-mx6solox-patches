# Need to remove CONFIG_CPU_IDLE so the core doesn't go to low 
# power mode during JTAG debug

do_configure_append() {
	# bbnote "Squashing CONFIG_CPU_IDLE for proper jtag operation"
	# sed -i 's/CONFIG_CPU_IDLE=y/# CONFIG_CPU_IDLE is not set/' .config
}

# Note: This is not the right way to solve this problem.  The "Right Way"
# is to disable the cpuidle governors throught the kernel api provided
# via sysfs.  Do this instead:
#
# echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state0/disable
# echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state1/disable
#
# This preserves the low power transition when not doing debugging
