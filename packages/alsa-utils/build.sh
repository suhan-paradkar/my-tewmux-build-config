TERMUX_PKG_HOMEPAGE=http://www.alsa-project.org
TERMUX_PKG_VERSION=1.2.5.1
TERMUX_PKG_SRCURL=ftp://ftp.alsa-project.org/pub/utils/alsa-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=9c169ae37a49295f9b97b92ace772803daf6b6510a19574e0b78f87e562118d0
TERMUX_PKG_DEPENDS="alsa-lib, ncurses, ndk-sysroot"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-udev-rules-dir=$TERMUX_PREFIX/lib/udev/rules.d --with-asound-state-dir=$TERMUX_PREFIX/var/lib/alsa --disable-alsamixer --disable-rst2man --disable-alsatest --disable-bat"
TERMUX_PKG_LICENSE="GPL-2.0"
termux_step_pre_configure() {
    LDFLAGS+=" -L@TERMUX_PREFIX@/lib"
    LDFLAGS+=" -llog -lm -latopology"
}
