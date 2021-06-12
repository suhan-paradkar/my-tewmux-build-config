TERMUX_PKG_VERSION=248
termux_step_get_source() {
	mkdir $TERMUX_TOPDIR/libudev/src
	cp $TERMUX_PKG_BUILDER_DIR/* $TERMUX_TOPDIR/libudev/src
}
