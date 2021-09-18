TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Open Source, cross-platform JavaScript runtime environment"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
# Note: package build may fail on Github Actions CI due to out-of-memory
# condition. It should be built locally instead.
TERMUX_PKG_VERSION=16.9.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=97f50ec53c050e7ac97bdbe5586aaca380dd23064064c85a1f2017a35244131c
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/termux/termux-packages/issues/462.
TERMUX_PKG_DEPENDS="libc++, openssl, c-ares, libicu, zlib"
TERMUX_PKG_CONFLICTS="nodejs-lts, nodejs-current"
TERMUX_PKG_BREAKS="nodejs-dev"
TERMUX_PKG_REPLACES="nodejs-current, nodejs-dev"
TERMUX_PKG_SUGGESTS="clang, make, pkg-config, python"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
# Build fails on x86_64 with:
# g++ -rdynamic -m64 -pthread -m64 -fPIC  -o /home/builder/.termux-build/nodejs/src/out/Release/mksnapshot ...
# /usr/bin/ld: /home/builder/.termux-build/nodejs/src/out/Release/obj.host/v8_base_without_compiler/deps/v8/src/api/api.o: 
# in function `v8::TryHandleWebAssemblyTrapPosix(int, siginfo_t*, void*)':
# api.cc:(.text._ZN2v829TryHandleWebAssemblyTrapPosixEiP9siginfo_tPv+0x5):
# undefined reference to `v8::internal::trap_handler::TryHandleSignal(int, siginfo_t*, void*)'
# /usr/bin/ld: /home/builder/.termux-build/nodejs/src/out/Release/obj.host/v8_base_without_compiler/deps/v8/src/trap-handler/handler-outside.o:
# in function `v8::internal::trap_handler::EnableTrapHandler(bool)':
# handler-outside.cc:(.text._ZN2v88internal12trap_handler17EnableTrapHandlerEb+0x25):
# undefined reference to `v8::internal::trap_handler::RegisterDefaultTrapHandler()'
# collect2: error: ld returned 1 exit status
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_post_get_source() {
	# Prevent caching of host build:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_host_build() {
	local ICU_VERSION=69.1
	local ICU_TAR=icu4c-${ICU_VERSION//./_}-src.tgz
	local ICU_DOWNLOAD=https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION//./-}/$ICU_TAR
	termux_download \
		$ICU_DOWNLOAD\
		$TERMUX_PKG_CACHEDIR/$ICU_TAR \
		4cba7b7acd1d3c42c44bb0c14be6637098c7faf2b330ce876bc5f3b915d09745
	tar xf $TERMUX_PKG_CACHEDIR/$ICU_TAR
	cd icu/source
	if [ "$TERMUX_ARCH_BITS" = 32 ]; then
		./configure --prefix $TERMUX_PKG_HOSTBUILD_DIR/icu-installed \
			--disable-samples \
			--disable-tests \
			--build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
	else
		./configure --prefix $TERMUX_PKG_HOSTBUILD_DIR/icu-installed \
			--disable-samples \
			--disable-tests
	fi
	make -j $TERMUX_MAKE_PROCESSES install
}

termux_step_configure() {
	local DEST_CPU
	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="ia32"
		LDFLAGS+=" -u __atomic_fetch_add_8 -u __atomic_load_8 -u __atomic_compare_exchange_8 -latomic"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	export GYP_DEFINES="host_os=linux"
	export CC_host=gcc
	export CXX_host=g++
	export LINK_host="g++ -Wl,--no-as-needed -ldl -lz"

	LDFLAGS+=" -ldl"
	# See note above TERMUX_PKG_DEPENDS why we do not use a shared libuv.
	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-zlib \
		--with-intl=system-icu \
		--cross-compiling

	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/lib
	perl -p -i -e "s@LIBS := \\$\\(LIBS\\)@LIBS := -L$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/lib -lpthread -licui18n -licuuc -licudata@" \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/mksnapshot.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/torque.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/bytecode_builtins_list_generator.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/v8_libbase.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/gen-regexp-special-case.host.mk
}
