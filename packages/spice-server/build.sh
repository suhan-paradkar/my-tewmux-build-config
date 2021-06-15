TERMUX_PKG_DESCRIPTION="Spice protocol for termux"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=0.14.91
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/spice/spice.git
TERMUX_PKG_DEPENDS="libjpeg-turbo, zlib, openssl, glib, libpixman, gstreamer, gst-plugins-base, liborc, liblz4, libsasl, spice-protocol"
termux_step_make() {
CXXLAGS+="-I$TERMUX_PREFIX/spice-1/spice"
ninja
}
