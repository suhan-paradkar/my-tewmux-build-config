TERMUX_PKG_DESCRIPTION="The Rust toolchain installer"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.24.3
TERMUX_PKG_SRCURL=https://github.com/rust-lang/rustup.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"
termux_step_pre_configure() {
CFLAGS="-I@TERMUX_PREFIX@/include"
termux_setup_rust
}
termux_step_configure() {
cargo build
}
