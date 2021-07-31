TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 8 Java Runtime Environment (prerelease)"
TERMUX_PKG_VERSION=8.1.0
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_HOMEPAGE=https://github.com/AdoptOpenJDK/openjdk-jdk8u
TERMUX_PKG_DEPENDS="freetype, libffi, libpng, ca-certificates-java, alsa-lib, libx11, libxext, libxtst, libxt, libxrender"
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCURL=https://github.com/PojavLauncherTeam/openjdk-multiarch-jdk8u.git

termux_step_pre_configure() {
        if [ "$TERMUX_ARCH" = "arm" ]; then
                export JVM_VARIANTS="client"
        else
                export JVM_VARIANTS="server"
        fi

        # Provide fake gcc.
        mkdir -p $TERMUX_PKG_SRCDIR/wrappers-bin
        cat <<- MEOF > $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang
        #!/bin/bash
        name=\$(basename "\$0")
        if [ "\$name" = "android-wrapped-clang" ]; then
                name=gcc
                compiler=$CC
        else
                name=g++
                compiler=$CXX
        fi
        if [ "\$1" = "--version" ]; then
                echo "${TERMUX_HOST_PLATFORM/arm/armv7a}-\${name} (GCC) 4.9 20140827 (prerelease)"
                echo "Copyright (C) 2014 Free Software Foundation, Inc."
                echo "This is free software; see the source for copying conditions.  There is NO"
                echo "warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
                exit 0
        fi
        exec \$compiler "\${@/-fno-var-tracking-assignments/}"
        MEOF
        chmod +x $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang
        ln -sfr $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang \
                $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang++
        CC=$TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang
        CXX=$TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang++

        cat <<- LEOF > $TERMUX_STANDALONE_TOOLCHAIN/devkit.info
        DEVKIT_NAME="Android"
        DEVKIT_TOOLCHAIN_PATH="\$DEVKIT_ROOT"
        DEVKIT_SYSROOT="\$DEVKIT_ROOT/sysroot"
        LEOF

        # OpenJDK uses same makefile for host and target builds, so we can't
        # easily patch usage of librt and libpthread. Using linker scripts
        # instead.
        echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/librt.so
        echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/libpthread.so
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
