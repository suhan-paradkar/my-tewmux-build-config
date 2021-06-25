TERMUX_PKG_DESCRIPTION="The systemd System and Service Manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=248
TERMUX_PKG_SRCURL=https://github.com/systemd/systemd.git
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Drootprefix=$TERMUX_PREFIX"
TERMUX_PKG_DEPENDS="libcap, ndk-sysroot, libcrypt, termux-tools, util-linux"
termux_step_pre_configure() {
rm -f $TERMUX_PKG_SRCDIR/configure
}
