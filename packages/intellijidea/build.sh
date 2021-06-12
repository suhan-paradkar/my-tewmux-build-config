TERMUX_PKG_DESCRIPTION="Intellijidea for termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=212.4037.9
TERMUX_PKG_SRCURL=https://github.com/JetBrains/intellij-community/archive/refs/tags/idea/212.4037.9.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SHA256=76039082fb8510dcf888ee79b52bce9df807dfa7a57c83b7ce846b74f49462ca
termux_step_configure() {
getPlugins.sh
}
termux_step_make() {
return 0
}
termux_step_make_install() {
return 0
}
