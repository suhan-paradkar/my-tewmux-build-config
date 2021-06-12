TERMUX_PKG_HOMEPAGE=https://github.com/twaik/liblorie
TERMUX_PKG_DESCRIPTION="liblorie"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SRCURL=https://github.com/twaik/liblorie.git
TERMUX_0KG_GIT_BRANCH="master"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="libandroid-shmem, libwayland, xorg-server"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dandroid_client=true -Dxorg_module=true"
