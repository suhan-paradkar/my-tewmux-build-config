TERMUX_PKG_HOMEPAGE=https://gradle.org/
TERMUX_PKG_DESCRIPTION="Adaptable, fast automation for all"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.1.1
TERMUX_PKG_SHA256=9bb8bc05f562f2d42bdf1ba8db62f6b6fa1c3bf6c392228802cc7cb0578fe7e0
TERMUX_PKG_DEPENDS="golang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	mkdir /home/builder/.termux-build/ndk/src
	cd $TERMUX_PKG_SRCDIR
	repo init -u https://android.googlesource.com/platform/manifest -b llvm-toolchain
	repo sync -c -j4
}
