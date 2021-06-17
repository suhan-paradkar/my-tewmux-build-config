TERMUX_PKG_HOMEPAGE=http://www.alsa-project.org
TERMUX_PKG_VERSION=1.2.5
TERMUX_PKG_SRCURL=ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=42eef98433d2c8d11f1deeeb459643619215a75aa5a5bbdd06a794e4c413df20
TERMUX_PKG_DEPENDS="alsa-lib"
TERMUX_PKG_LICENSE="GPL-2.0"
termux_step_post_make_install() {
    cp $TERMUX_PKG_BUILDER_DIR/asound.conf $TERMUX_PREFIX/etc
}
