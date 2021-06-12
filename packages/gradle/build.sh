TERMUX_PKG_DESCRIPTION="Gradle"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=7.0.2
TERMUX_PKG_SRCURL=https://github.com/gradle/gradle.git
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_configure() {
./gradlew
}
termux_step_make() {
return 0
}
termux_step_make_install() {
mkdir $TERMUX_PREFIX/gradle
mv $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/gradle
}
