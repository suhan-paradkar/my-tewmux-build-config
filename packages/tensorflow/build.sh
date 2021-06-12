TERMUX_PKG_DESCRIPTION="Tensorflow for termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_SRCURL=https://github.com/tensorflow/tensorflow.git
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_configure() {
pip3 install numpy
./configure
}
termux_step_make() {
bazel build //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
}

