TERMUX_PKG_HOMEPAGE=https://github.com/facebook/zstd
TERMUX_PKG_DESCRIPTION="Zstandard compression."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/facebook/zstd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=acf714d98e3db7b876e5b540cbf6dee298f60eb3c0723104f6d3f065cd60d6a8
TERMUX_PKG_DEPENDS="liblzma, zlib"
TERMUX_PKG_BREAKS="zstd-dev"
TERMUX_PKG_REPLACES="zstd-dev"
TERMUX_PKG_BUILD_IN_SRC=true