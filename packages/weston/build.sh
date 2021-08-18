TERMUX_PKG_DESCRIPTION="Weston compositor for wayland"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_SRCURL=https://github.com/wayland-project/weston.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libinput, libxkbcommon, libwayland, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dimage-webp=false \
			-Drenderer-gl=false \
			-Dlauncher-logind=false \
			-Dbackend-drm-screencast-vaapi=false \
			-Dbackend-rdp=false \
			-Dcolor-management-lcms=false \
			-Dcolor-management-colord=false \
			-Dsystemd=false \
			-Dremoting=false \
			-Dpipewire=false \
			-Ddemo-clients=false"
