TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/geckodriver
TERMUX_PKG_DESCRIPTION="Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.29.1
TERMUX_PKG_SRCURL=https://github.com/mozilla/geckodriver/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d2f0868afacc46dccc021e3cdd54c37def1f84d0e64e6f251b27f3d232e48426
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/geckodriver \
		"$TERMUX_PREFIX"/bin/
}
