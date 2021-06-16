TERMUX_PKG_DESCRIPTION="Bazel for android"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_POG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=4.1.0
TERMUX_PKG_SRCURL=https://github.com/bazelbuild/bazel.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="protobuf, libprotobuf-c"
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_HOSTBUILD=true
termux_step_host_build() {
sudo apt install curl gnupg
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && sudo apt install bazel
sudo apt install bazel
}

termux_step_configure() {
LDFLAGS+=" -llog"
bazel build //src:bazel-dev --compilation_mode=opt -copts="-llog"
}
termux_step_make() {
return 0
}
termux_step_make_install() {
cp bazel-bin/src/bazel-dev $TERMUX_PREFIX/share/bazel
}
