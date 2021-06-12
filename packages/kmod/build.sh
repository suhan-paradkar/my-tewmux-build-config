TERMUX_PKG_HOMEPAGE=https://mate-panel.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-panel contains the MATE panel, the libmate-panel-applet library and several applets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=28
TERMUX_PKG_SRCURL=https://github.com/lucasdemarchi/kmod.git
TERMUX_PKG_NO_STATICSPLIT=true
termux_step_pre_configure() {
	autoreconf -fi
}
