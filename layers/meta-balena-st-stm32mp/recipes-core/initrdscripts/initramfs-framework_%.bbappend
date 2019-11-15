# ST's default BSP enables Watchdog and its timer is 32 seconds
# by default. There is a bug that Linux kernel watchdog driver does not handle
# the watchdog propery so that watchdog is triggered before entering systemd,
# causing infinite rebooting.
# 
# Reference: https://github.com/balena-os/meta-balena/pull/1669
#            https://community.st.com/s/question/0D50X0000BL8wcRSQR/linux-watchdog-driver-is-broken?t=1568948904555
#

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://watchdog \
    "

do_install_append() {
    install -m 0755 ${WORKDIR}/watchdog ${D}/init.d/69-watchdog
}

PACKAGES_append = " \
    initramfs-module-watchdog \
    "

SUMMARY_initramfs-module-watchdog = "initramfs watchdog"
RDEPENDS_initramfs-module-watchdog = "${PN}-base busybox"
FILES_initramfs-module-watchdog = "/init.d/69-watchdog"
