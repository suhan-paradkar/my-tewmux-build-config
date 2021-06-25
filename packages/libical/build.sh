TERMUX_PKG_HOMEPAGE=http://libical.github.io/libical/
TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.10
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f933b3e6cf9d56a35bb5625e8e4a9c3a50239a85aea05ed842932c1a1dc336b4
TERMUX_PKG_DEPENDS="libc++, libxml2, glib, gobject-introspection, libicu, doxygen, glib-bin"
TERMUX_PKG_BREAKS="libical-dev"
TERMUX_PKG_REPLACES="libical-dev"

TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DSHARED_ONLY=true -DICAL_GLIB=true -DUSE_BUILTIN_TZDATA=true -DPERL_EXECUTABLE=/usr/bin/perl -DIMPORT_ICAL_GLIB_SRC_GENERATOR=/usr/local/lib64/cmake/LibIcal/IcalGlibSrcGenerator.cmake"
TERMUX_PKG_HOSTBUILD=true
termux_step_host_build() {
	termux_download \
		$TERMUX_PKG_SRCURL\
		$TERMUX_PKG_CACHEDIR/libical-3.0.10.tar.gz \
		$TERMUX_PKG_SHA256
	tar xf $TERMUX_PKG_CACHEDIR/libical-3.0.10.tar.gz
patch -p0 < $TERMUX_PKG_BUILDER_DIR/libical.patch.beforehostbuild	
cd libical-3.0.10
mkdir build && cd build
cmake ..
make
sudo make install
}
