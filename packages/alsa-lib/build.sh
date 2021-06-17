TERMUX_PKG_HOMEPAGE=http://www.alsa-project.org
TERMUX_PKG_VERSION=1.2.5.1
TERMUX_PKG_DEPENDS="libandroid-shmem, python"
TERMUX_PKG_SRCURL=ftp://ftp.alsa-project.org/pub/lib/alsa-lib-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=628421d950cecaf234de3f899d520c0a6923313c964ad751ffac081df331438e
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="--disable-mixer --enable-topology"
termux_step_pre_configure() {
    CPPFLAGS+="-DTERMUX_SHMEM_STUBS -DTERMUX_SEMOPS_STUBS"
}
