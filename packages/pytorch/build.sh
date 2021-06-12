TERMUX_PKG_DESCRIPTION="Pytorch"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_VERSION=1.8.1
TERMUX_PKG_SRCURL=https://github.com/pytorch/pytorch.git
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_configure() {
python setup.py install
}
termux_step_make() {
return 0
}
termux_step_make_install() {
return 0
}
