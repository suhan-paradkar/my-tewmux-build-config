TERMUX_PKG_HOMEPAGE=https://github.com/schollz/croc
TERMUX_PKG_DESCRIPTION="Easily and securely send things from one computer to another."
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.3.0
TERMUX_PKG_SRCURL=https://github.com/schollz/croc/releases/download/v${TERMUX_PKG_VERSION}/croc_${TERMUX_PKG_VERSION}_src.tar.gz
TERMUX_PKG_SHA256=aa4cbb9e3dac804ffb5c23b3a3dd23853a1476b315f7e550467956fa4cdcec3a
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	go build -o croc -trimpath
}

termux_step_make_install() {
	install -m755 croc $TERMUX_PREFIX/bin/croc
}
