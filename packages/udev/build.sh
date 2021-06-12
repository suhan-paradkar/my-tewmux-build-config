TERMUX_PKG_HOMEPAGE=https://code.launchpad.net/udev
TERMUX_PKG_DESCRIPTION="device manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=173
TERMUX_PKG_SRCURL=git://git.kernel.org/pub/scm/linux/hotplug/udev.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="util-linux, kmod"

termux_step_pre_configure() {
	autoreconf -fi
}
