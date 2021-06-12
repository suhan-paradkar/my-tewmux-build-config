TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 11 Java Runtime Environment (prerelease)"
TERMUX_PKG_VERSION="11.0"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_HOMEPAGE=http://openjdk.java.net/projects/jdk11
TERMUX_PKG_DEPENDS="freetype, libffi, libpng, ca-certificates-java, alsa-lib, libx11, libxext, libxtst, libxt, libxrender"
TERMUX_PKG_SRCURL=https://github.com/openjdk/jdk11.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_configure() {
bash ./configure  --with-toolchain-type=clang --with-extra-cflags="-fstack-protector-strong -Oz" --with-extra-cxxflags="-fstack-protector-strong -Oz" --with-extra-ldflags="-L/data/data/com.termux/files/usr/lib -Wl,-rpath=/data/data/com.termux/files/usr/lib -fopenmp -static-openmp -Wl,--enable-new-dtags -Wl,--as-needed -Wl,-z,relro,-z,now" --openjdk-target=$TERMUX_ARCH-linux-android
}
