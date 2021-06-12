TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 keyboard file manipulation library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=20
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libxkbfile-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=758dbdaa20add2db4902df0b1b7c936564b7376c02a0acd1f2a331bd334b38c7
TERMUX_PKG_DEPENDS="libx11, libxau, libxcb, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"