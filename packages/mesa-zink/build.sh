TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=21.2
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/mesa/mesa.git
TERMUX_PKG_DEPENDS="libandroid-shmem, libexpat, libdrm, libx11, libxdamage, libxext, libxml2, libxshmfence, zlib, libandroid-shmem-static"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_CONFLICTS="libmesa, mesa"
TERMUX_PKG_REPLACES="libmesa"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dllvm=disabled"
termux_step_get_source() {
	git clone $TERMUX_PKG_SRCURL $TERMUX_PKG_SRCDIR -b $TERMUX_PKG_GIT_BRANCH
}

termux_step_post_get_source() {
	cd $TERMUX_PKG_SRCDIR
	git checkout b8970120545b3cb250821013cb459bf4d2acfda4
}

termux_step_pre_configure() {
	rm -rf $TERMUX_PKG_SRCDIR/configure
	export LIBS="-landroid-shmem -latomic"
	CFLAGS+="-Wno-error"
}

termux_step_post_massage() {
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libGL.so.1" ]; then
		ln -sf libGL.so libGL.so.1
	fi
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/mesa $TERMUX_PKG_BUILDER_DIR/LICENSE
}
