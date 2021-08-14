TERMUX_PKG_HOMEPAGE=https://musl.libc.org/
TERMUX_PKG_DESCRIPTION="musl is an implementation of the C standard library built on top of the Linux system call API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_SRCURL=https://musl.libc.org/releases/musl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9b969322012d796dc23dda27a35866034fa67d8fb67e0e2c45c913c3d43219dd
TERMUX_PKG_BLACKLISTED_ARCH="x86_64, i686"
termux_step_configure() {
	nkdir $TERMUX_PREFIX/opt/musl
	./configure --prefix=$TERMUX_PREFIX/opt/musl
}

