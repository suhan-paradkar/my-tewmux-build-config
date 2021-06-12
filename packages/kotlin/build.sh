TERMUX_PKG_DESCRIPTION="Kotlin"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.5.10
TERMUX_PKG_SRCURL=https://github.com/JetBrains/kotlin.git
TERMUC_PKG_ARCH_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_configure() {
./gradlew
}
termux_step_make() {
return 0
}
termux_step_make_install() {
mkdir $TERMUX_PREFIX/share/kotlin
mv $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/share/kotlin
}
