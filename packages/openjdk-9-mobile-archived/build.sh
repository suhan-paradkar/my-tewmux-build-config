TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 8 Java Runtime Environment (prerelease)"
TERMUX_PKG_VERSION=9.1.0
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_DEPENDS="freetype, libffi, libpng, ca-certificates-java, alsa-lib, libx11, libxext, libxtst, libxt, libxrender"
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	hg clone http://hg.openjdk.java.net/mobile/jdk9 $TERMUX_PKG_SRCDIR
}

termux_step_configure() {
bash ./configure \
    --openjdk-target=$TERMUX_HOST_PLATFORM \
    --with-extra-cflags="$CFLAGS" \
    --with-extra-cxxflags="$CFLAGS" \
    --with-extra-ldflags="$LDFLAGS" \
    --enable-option-checking=fatal \
    --with-jdk-variant=normal \
    --with-debug-level=release
}
