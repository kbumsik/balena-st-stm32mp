# u-boot-stm32mp-extlinux is neccesary to U-Boot for STM32MP, as it provides
# boot.scr.cmd and extlinux.conf scripts.
# The original bb script only has do_install, but we need to use do_deploy
# to install this in resin-image.
inherit deploy
deltask do_install

do_deploy() {
    # Install boot script
    # [NOTE]: This will copy boot.scr.uimg to deploy if exists.
    # boot.scr.uimg won't exist if there is only one kind of boot device in
    # UBOOT_EXTLINUX_CONFIG_FLAGS so that there is only one entry in ${B} directory.
    # If there is no boot.scr.uimg U-Boot won't run rproc-m4-fw.elf to boot
    # coprocessor (Cortex-M4).
    # So enable this consider adding stm32mp1-mx.conf from meta-st-stm32mp-addons
    # See: https://github.com/STMicroelectronics/meta-st-stm32mp-addons/blob/thud/conf/machine/stm32mp1-mx.conf
    if [ -e ${UBOOT_EXTLINUX_BOOTSCR_IMG} ]; then
        install -m 755 ${UBOOT_EXTLINUX_BOOTSCR_IMG} ${DEPLOYDIR}
    fi
    # Install extlinux files
    if ! [ -z "$(ls -A ${B})" ]; then
        cp -r ${B}/* ${DEPLOYDIR}
    fi
}

addtask deploy after do_compile
