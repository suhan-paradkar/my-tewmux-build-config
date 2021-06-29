TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 8 Java Runtime Environment (prerelease)"
TERMUX_PKG_VERSION=8.1.0
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_HOMEPAGE=https://github.com/AdoptOpenJDK/openjdk-jdk8u
TERMUX_PKG_DEPENDS="freetype, libffi, libpng, ca-certificates-java, alsa-lib, libx11, libxext, libxtst, libxt, libxrender"
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
if [ $TERMUX_ARCH="arm" ] || [$TERMUX_ARCH="i686"]
then
  git clone --depth 1 https://github.com/PojavLauncherTeam/openjdk-aarch32-jdk8u $TERMUX_PKG_SRCDIR
  export JVM_VARIANTS=server
else
  git clone --depth 1 https://github.com/PojavLauncherTeam/openjdk-aarch64-jdk8u $TERMUX_PKG_SRCDIR
  export JVM_VARIANTS=server
fi
}

termux_step_configure() {
bash ./configure \
    --openjdk-target=$TERMUX_HOST_PLATFORM \
    --with-extra-cflags="$CFLAGS" \
    --with-extra-cxxflags="$CFLAGS" \
    --with-extra-ldflags="$LDFLAGS" \
    --enable-option-checking=fatal \
    --with-jdk-variant=normal \
    --with-jvm-variants=$JVM_VARIANTS \
    --with-devkit=$TERMUX_STANDALONE_TOOLCHAIN \
    --with-debug-level=release
}
