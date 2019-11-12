inherit resin-u-boot

FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

UBOOT_KCONFIG_SUPPORT = "1"
SRC_URI_remove = "file://resin-specific-env-integration-kconfig.patch"
SRC_URI_append = " \
    file://0001-increase-env-size.patch \
    file://0001-resin-specific-env-integration-kconfig_REWORKED.patch \
    file://0001-st-defconfig-for-resin-u-boot.patch \
    file://0002-bootcmd-resin-integration.patch \
    "

RESIN_BOOT_PART_stm32mp1-disco = "4"
RESIN_DEFAULT_ROOT_PART_stm32mp1-disco = "5"

################################################################################
# Appending config_resin.h to configure U-Boot environment.
# See also: u-boot-stm32mp patches to add env_resin.h
################################################################################
# Must be one of UBOOT_DEVICETREE (The same as KERNEL_DEVICETREE)
UBOOT_DEFULAT_DEVICETREE ?= "stm32mp157c-dk2-m4-examples.dtb"
# These will be added to resin_env.h. See resin-u-boot.bbclass
# [TODO] Add bootdelay=0 for production image?
UBOOT_VARS_append = " KERNEL_IMAGETYPE \
                     UBOOT_DEFULAT_DEVICETREE \
                     "
# Add serial console parameter, Default should be "console=ttySTM0,115200"
U_BOOT_SERIAL_CONSOLE = "console=${@d.getVar('SERIAL_CONSOLE').split()[1]},${@d.getVar('SERIAL_CONSOLE').split()[0]}"
OS_KERNEL_CMDLINE_append = " ${@bb.utils.contains('DEVELOPMENT_IMAGE','1', '${U_BOOT_SERIAL_CONSOLE}', '',d)}"
# resin-rootA fs type
OS_KERNEL_CMDLINE_append = " rootfstype=ext4 "

# Initramfs debugging
#OS_KERNEL_CMDLINE_append = " debug verbose shell-debug "
# Initramfs shell
#OS_KERNEL_CMDLINE_append = " shell=before:watchdog "

################################################################################
# Configuration for ST's extlinux generation.
# We currently don't use extlinux but configure it just in case.
# See st-machine-extlinux-config-stm32mp.inc and extlinuxconf-stm32mp.bbclass
################################################################################
# [TODO] This does not work...
EXTLINUX_ROOT_SDCARD_stm32mp1-disco = "root=/dev/mmcblk0p5"
# UBOOT_SPLASH_IMAGE = "../splash/resin-logo.png"
