TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/en-US/firefox/
TERMUX_PKG_DESCRIPTION="Open source privacy browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_VERSION=83.0
NOCONFIGURE=true
termux_step_get_source() {
	pip3 install mercurial
	echo "export PATH=\"$(python3 -m site --user-base)/bin:$PATH\"" >> ~/.bashrc
	curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O
	python3 bootstrap.py
	rm bootstrap.py
	mv mozilla-unified/* src/
	rm -r mozilla-unified
}
termux_step_make() {
	./mach build
}
termux_step_make_install() {
	./mach run
}
