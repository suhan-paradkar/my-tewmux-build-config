TERMUX_PKG_HOMEPAGE=http://ant.apache.org/
TERMUX_PKG_DESCRIPTION="Java based build tool like make"
TERMUX_PKG_VERSION=1.10.10
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net//ant/binaries/apache-ant-${TERMUX_PKG_VERSION}-bin.tar.bz2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SHA256=786b174bf4eb291c1d203555fd5f349a748e15bbc060f0418532e7eb2461874e
TERMUX_PKG_API_LEVEL=26
TERMUX_PKG_LICENSE="Apache-2.0"
termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/ant/lib

	for jar in ant ant-launcher; do
		$ANDROID_HOME/build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/dx \
			--dex --min-sdk-version=26 \
			--output=$TERMUX_PREFIX/share/ant/lib/${jar}.jar \
			lib/${jar}.jar
	done

	install $TERMUX_PKG_BUILDER_DIR/ant $TERMUX_PREFIX/bin/ant
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ant
}
