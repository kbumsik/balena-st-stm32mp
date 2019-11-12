# The boot device must be GPT-formatted.
PARTITION_TABLE_TYPE = "gpt"
BALENA_BOOT_FAT32 = "1"

IMAGE_FSTYPES_append_stm32mp1-disco = " resinos-img"

IMAGE_INSTALL_append = " enable-overcommit"

do_rootfs[depends] += " \
    u-boot-stm32mp-extlinux:do_deploy \
    u-boot-stm32mp-splash:do_deploy \
    "

# [TODO]: Maybe add GPU libraries later
# PACKAGE_INSTALL += " \
#     ${@bb.utils.contains('MACHINE_FEATURES', 'gpu', d.getVar('GPU_USERLAND_LIBRARIES_INSTALL') or '', '', d)} \
#     "

RESIN_BOOT_PARTITION_FILES_stm32mp1-disco = " \
    extlinux/extlinux.conf:/extlinux/extlinux.conf \
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
    stm32mp157c-dk2-a7-examples.dtb: \
    stm32mp157c-dk2.dtb: \
    stm32mp157c-dk2-m4-examples.dtb: \
    splash.bmp: \
    "

# We already add the kernel through the kernel-image-initramfs package
IMAGE_INSTALL_remove = "kernel-image"

# See u-boot-stm32mp-extlinux.bbappend about boot.scr.uimg
# RESIN_BOOT_PARTITION_FILES_append_tm32mp1-disco += " \
#     boot.scr.uimg:/boot.scr.uimg \
#     "

# Partition configuration
def mul(a, b):
    import operator
    return operator.mul(a, b)
# This must be a multiple of RESIN_IMAGE_ALIGNMENT.
# By default this will be evaluated to 8MB
DEVICE_SPECIFIC_SPACE = "${@mul(${RESIN_IMAGE_ALIGNMENT}, 1)}"

# Write STM32MP1 specific partitions
device_specific_configuration() {
    FSBL_IMG="tf-a-stm32mp157c-dk2-trusted.stm32"
    SSBL_IMG="u-boot-stm32mp157c-dk2-trusted.stm32"

    # Not that the numbers presented here are in units of sectors (512 byte)
    # It differes from Resin-image's preferred units (1KiB)
    # fsbl1
    OPTS="fsbl1"
    START=34
    # END=${DEVICE_SPECIFIC_SPACE}
    END=$(expr $START \+ 511) # 545
    parted -s ${RESIN_RAW_IMG} unit s mkpart $OPTS $START $END
    dd if=${DEPLOY_DIR_IMAGE}/$FSBL_IMG of=${RESIN_RAW_IMG} conv=fdatasync,notrunc seek=1 bs=$(expr $START \* 512)
    
    # fsbl2 (a backup copy of fsbl)
    OPTS="fsbl2"
    START=546
    END=$(expr $START \+ 511) # 1057
    parted -s ${RESIN_RAW_IMG} unit s mkpart $OPTS $START $END
    dd if=${DEPLOY_DIR_IMAGE}/$FSBL_IMG of=${RESIN_RAW_IMG} conv=fdatasync,notrunc seek=1 bs=$(expr $START \* 512)

    # ssbl
    OPTS="ssbl"
    START=1058
    END=$(expr $START \+ 4095) # 5153
    parted -s ${RESIN_RAW_IMG} unit s mkpart $OPTS $START $END
    dd if=${DEPLOY_DIR_IMAGE}/$SSBL_IMG of=${RESIN_RAW_IMG} conv=fdatasync,notrunc seek=1 bs=$(expr $START \* 512)

    if [ "$(expr $END \* 512)" -ge "$(expr ${DEVICE_SPECIFIC_SPACE} \* 1024)" ]; then
        bbfatal "STM32MP1 specific space is larger than DEVICE_SPECIFIC_SPACE."
    fi
}
