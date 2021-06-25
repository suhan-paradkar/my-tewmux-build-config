TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/
TERMUX_PKG_DESCRIPTION="GNU C compiler"
TERMUX_PKG_DEPENDS="binutils, libgmp, libmpfr, libmpc, ndk-sysroot, libgcc, libisl"
TERMUX_PKG_VERSION=12
TERMUX_PKG_GIT_BRANCH=basepoints/gcc-12
TERMUX_PKG_SRCURL=https://github.com/gcc-mirror/gcc.git
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-languages=c,c++ --with-system-zlib --disable-multilib --disable-lto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --target=$TERMUX_HOST_PLATFORM"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-gmp=$TERMUX_PREFIX --with-mpfr=$TERMUX_PREFIX --with-mpc=$TERMUX_PREFIX"
# To build gcc as a PIE binary:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-stage1-ldflags=\"-specs=$TERMUX_SCRIPTDIR/termux.spec\""
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-isl-include=$TERMUX_PREFIX/include --with-isl-lib=$TERMUX_PREFIX/lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-isl-version-check"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-tls"

if [ "$TERMUX_ARCH" = "arm" ]; then
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-arch=armv7-a --with-fpu=neon --with-float=hard"
elif [ "$TERMUX_ARCH" = "aarch64" ]; then
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-arch=armv8-a"
elif [ "$TERMUX_ARCH" = "i686" ]; then
        # -mstackrealign -msse3 -m32
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-arch=i686 --with-tune=atom --with-fpmath=sse"
fi



termux_step_make () {
	make -j $TERMUX_MAKE_PROCESSES all-gcc
}

termux_step_make_install () {
	make install-gcc
}

termux_step_post_make_install () {
	# Android 5.0 only supports PIE binaries, so build that by default with a specs file:
	local GCC_SPECS=$TERMUX_PREFIX/lib/gcc/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_VERSION/specs
	cp $TERMUX_SCRIPTDIR/termux.spec $GCC_SPECS

	if [ $TERMUX_ARCH = "i686" ]; then
		# See https://github.com/termux/termux-packages/issues/3
		# and https://github.com/termux/termux-packages/issues/14
		cat >> $GCC_SPECS <<HERE

*link_emulation:
elf_i386

*dynamic_linker:
/system/bin/linker
HERE
	fi

	# Replace hardlinks with symlinks:
	cd $TERMUX_PREFIX/bin
	rm ${TERMUX_HOST_PLATFORM}-g++; ln -s g++ ${TERMUX_HOST_PLATFORM}-g++
	rm ${TERMUX_HOST_PLATFORM}-gcc; ln -s gcc ${TERMUX_HOST_PLATFORM}-gcc
	rm ${TERMUX_HOST_PLATFORM}-gcc-${TERMUX_PKG_VERSION}; ln -s gcc ${TERMUX_HOST_PLATFORM}-gcc-${TERMUX_PKG_VERSION}
}
