TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/software/polkit/docs/latest/
TERMUX_PKG_DESCRIPTION="polkit is a toolkit for defining and handling authorizations.It is used for allowing unprivileged processes to speak to privileged processes."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.118
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/polkit/polkit.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="duktape, libelogind, libudev-stub"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="--with-duktape --enable-libsystemd-login=no --enable-libelogind=no"

termux_step_pre_configure() {
	autoreconf -fi
}
