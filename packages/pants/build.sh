TERMUX_PKG_DESCRIPTION="Pants Build system"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=release_2.2.4rc0
TERMUX_PKG_SRCURL=https://github.com/pantsbuild/pants.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TETMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="python"
termux_step_pre_configure() {
termux_setup_rust
CPPFLAGS="-I$TERMUX_PREFIX/include/python"
touch $TERMUX_PKG_SRCDIR/BUILDROOT
cp ./pants ./configure
}
