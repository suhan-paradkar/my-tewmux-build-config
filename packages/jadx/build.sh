TERMUX_PKG_DESCRIPTION="Jadx"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/skylot/jadx.git
TERMUX_PKG_BUILD_IN_SRC=true
_GRADLE_VERSION=7.0.2
TERMUX_PKG_GIT_BRANCH=master
termux_step_make() {
	# Download and use a new enough gradle version to avoid the process hanging after running:
	termux_download \
		https://services.gradle.org/distributions/gradle-$_GRADLE_VERSION-bin.zip \
		$TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-bin.zip \
		0e46229820205440b48a5501122002842b82886e76af35f0f3a069243dca4b3c
	mkdir $TERMUX_PKG_TMPDIR/gradle
	unzip -q $TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-bin.zip -d $TERMUX_PKG_TMPDIR/gradle

	# Avoid spawning the gradle daemon due to org.gradle.jvmargs
	# being set (https://github.com/gradle/gradle/issues/1434):
	rm gradle.properties

	export ANDROID_HOME
	export GRADLE_OPTS="-Dorg.gradle.daemon=false -Xmx1536m"

	$TERMUX_PKG_TMPDIR/gradle/gradle-$_GRADLE_VERSION/bin/gradle \
	::dist
}

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/jadx-gui $TERMUX_PREFIX
}
