TERMUX_PKG_DESCRIPTION="A GNU Based C compiler"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=11.1.0
TERMUX_PKG_SRCURL=https://github.com/gcc-mirror/gcc.git
TERMUX_PKG_GIT_BRANCH=releases/gcc-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libgmp, libmpfr, libmpc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="--disable-multilib --enable-werror --disable-libcpp"

