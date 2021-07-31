TERMUX_PKG_DESCRIPTION="Input device management and event handling library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.18.0
TERMUX_PKG_SRCURL=https://github.com/wayland-project/libinput.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libudev-stub, mtdev, libevdev, gtk3"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dlibwacom=false \
				-Ddocumentation=false"
