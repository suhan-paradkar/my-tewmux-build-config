TERMUX_PKG_HOMEPAGE=https://mate-panel.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-panel contains the MATE panel, the libmate-panel-applet library and several applets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.66
TERMUX_PKG_SRCURL=https://github.com/nss-dev/nss/archive/refs/tags/NSS_${TERMUX_PKG_VERSION//./_}_RTM.tar.gz
TERMUX_PKG_SHA256=4ee6220722ce89dd8fe0888f76ab95e997370d4e55dd1a809c2ee17655791700
termux_step_pre_configure() {
	./build.sh -t $TERMUX_ARCH
}
