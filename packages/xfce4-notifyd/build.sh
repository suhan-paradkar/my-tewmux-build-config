TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/notifyd/start
TERMUX_PKG_DESCRIPTION="Xfce4-notifyd is a notification service for the Xfce Desktop that implements most of the “server-side” portion of the Freedesktop notifications specification"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.6.2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-notifyd/${TERMUX_PKG_VERSION:0:3}/xfce4-notifyd-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=19ab84c6665c7819998f2269322d53f462c30963ce26042df23ae525e7d16545
TERMUX_PKG_DEPENDS="libxfce4ui, libxfce4util, xfce4-panel, libnotify"
