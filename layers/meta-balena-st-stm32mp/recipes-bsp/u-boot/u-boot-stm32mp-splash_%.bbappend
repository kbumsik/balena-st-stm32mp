# This adds a splash image for U-Boot. resin-image default only defines splash
# image for Linux, not U-Boot.
# The original bb script only has do_install, but we need to use do_deploy
# to install this in resin-image.
inherit deploy
deltask do_install

do_deploy() {
    install -m 644 ${S}/${UBOOT_SPLASH_SRC} ${DEPLOYDIR}/splash.bmp
}

addtask deploy after do_compile
