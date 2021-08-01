TERMUX_PKG_HOMEPAGE=https://github.com/skylot/jadx
TERMUX_PKG_DESCRIPTION="Dex to Java decompiler"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/skylot/jadx/releases/download/v$TERMUX_PKG_VERSION/jadx-$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=e6ae92be16edae2098b1a9951533feba4278bb18f00fbab54eb23a427b98d425
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/jadx
	mkdir -p $TERMUX_PREFIX/opt/jadx
	cp -r ./* $TERMUX_PREFIX/opt/jadx/
	for i in $TERMUX_PREFIX/opt/jadx/bin/*; do
		if [ ! -f "$i" ]; then
			continue
		fi
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}
