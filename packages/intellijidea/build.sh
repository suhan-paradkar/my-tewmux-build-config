TERMUX_PKG_HOMEPAGE=https://jetbrains.com/idea
TERMUX_PKG_DESCRIPTION="IntelliJ IDEA Community Edition & IntelliJ Platform"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2021.2
TERMUX_PKG_SRCURL=https://download.jetbrains.com/idea/ideaIC-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7c27799861fb1ba0d43a3565a1ec2be789e1871191be709f0e79f1e17d3571fe
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/intellijidea
	mkdir -p $TERMUX_PREFIX/opt/intellijidea
	cp -r ./* $TERMUX_PREFIX/opt/intellijidea/
	for i in $TERMUX_PREFIX/opt/intellijidea/bin/*; do
		if [ ! -f "$i" ]; then
			continue
		fi
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}
