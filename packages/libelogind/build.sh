TERMUX_PKG_HOMEPAGE=https://github.com/elogind/elogind
TERMUX_PKG_DESCRIPTION="Elogind User, Seat and Session Manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=246.10
TERMUX_PKG_SRCURL=https://github.com/elogind/elogind/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c490dc158c8f5bca8d00ecfcc7ad5af24d1c7b9e59990a0b3b1323996221a922
TERMUX_PKG_DEPENDS="libcap"
termux_step_pre_configure() {
	rm -f configure
}
