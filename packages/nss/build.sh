TERMUX_PKG_HOMEPAGE=https://mate-panel.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-panel contains the MATE panel, the libmate-panel-applet library and several applets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.67
TERMUX_PKG_SRCURL=https://github.com/nss-dev/nss/archive/refs/tags/NSS_${TERMUX_PKG_VERSION//./_}_RTM.tar.gz
TERMUX_PKG_SHA256=5b8c45cd94c389fd204dd3f0391517ec2a712bd3e1d52cb25af9a4f0015bec86
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_configure() {
	return 0
}
termux_step_make() {
	make
}
termux_step_make_install() {
	cp ../dist/*/bin $TERMUX_PREFIX/bin
	cp ../dist/*/bin $TERMUX_PREFIX/lib
}
