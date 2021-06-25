TERMUX_PKG_HOMEPAGE=https://github.com/servo/mozjs
TERMUX_PKG_DESCRIPTION="Rust bindings for SpiderMonkey for use with Servo."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=78
TERMUX_PKG_SRCURL=https://github.com/ptomato/mozjs.git
TERMUX_PKG_GIT_BRANCH=mozjs$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_pre_configure() {
export MOZ_DIST=$TERMUX_PKG_SRCDIR
export MOZ_TOPOBJDIR=$TERMUX_PKG_SRCDIR
termux_setup_rust
}
termux_step_configure() {
cargo build
}
