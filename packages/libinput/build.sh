TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libinput/
TERMUX_PKG_DESCRIPTION="Input device management and event handling library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.18.1
TERMUX_PKG_SRCURL=https://github.com/wayland-project/libinput.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libudev-stub, mtdev, libevdev, gtk3, check"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dlibwacom=false \
				-Ddocumentation=false"

termux_step_pre_configure() {
	termux_setup_cmake

}
