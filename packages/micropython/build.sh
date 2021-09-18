TERMUX_PKG_HOMEPAGE=http://micropython.org/
TERMUX_PKG_DESCRIPTION="Tiny implementation of Python programming language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.17
TERMUX_PKG_SRCURL=https://github.com/micropython/micropython/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c21dbf8144237b3dbe3847c9ad5264cd0f3104eb078c810b3986004cce8fcd70
TERMUX_PKG_DEPENDS="libffi, mbedtls"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
    cd ports/unix && {
        sed -i 's/MICROPY_SSL_AXTLS = 1/MICROPY_SSL_AXTLS = 0/g' mpconfigport.mk
        sed -i 's/MICROPY_SSL_MBEDTLS = 0/MICROPY_SSL_MBEDTLS = 1/g' mpconfigport.mk
        sed -i 's/-Werror//g' Makefile
        sed -i 's/LDFLAGS_MOD += -lpthread//g' Makefile
        cd -
    }
}

termux_step_make() {
    unset CC CPP CXX CFLAGS CXXFLAGS LD

    export BUILD_VERBOSE=1

    cd mpy-cross && {
        make \
            -j "${TERMUX_MAKE_PROCESSES}"
        cd -
    }

    cd ports/unix && {
        make \
            CPP="${TERMUX_HOST_PLATFORM}-clang -E" \
            CC="${TERMUX_HOST_PLATFORM}-clang -pie" \
            CROSS_COMPILE="${TERMUX_HOST_PLATFORM}-"
        cd -
    }
}

termux_step_make_install() {
    cd ports/unix && {
        install \
            -Dm700 \
            micropython \
            "${TERMUX_PREFIX}/bin/micropython"
        cd -
    }
}
