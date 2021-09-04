TERMUX_PKG_HOMEPAGE=https://jetbrains.com/pycharm
TERMUX_PKG_DESCRIPTION="For pure Python development"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=2021.2.1
TERMUX_PKG_SRCURL=https://download.jetbrains.com/python/pycharm-community-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c41ff10b200cd18afd8d46100597f78eb8ce85d97b0754120316673ee6f
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/pycharm
	mkdir -p $TERMUX_PREFIX/opt/pycharm
	cp -r ./* $TERMUX_PREFIX/opt/pycharm/
	ln -sfr $TERMUX_PREFIX/opt/pycharm/bin/pycharm.sh $TERMUX_PREFIX/bin/pycharm.sh
}
