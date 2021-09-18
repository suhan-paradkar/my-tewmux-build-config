TERMUX_PKG_HOMEPAGE=https://chezmoi.io
TERMUX_PKG_DESCRIPTION="Manage your dotfiles across multiple machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_SRCURL=https://github.com/twpayne/chezmoi/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a183c2d3d0d46314ae3647a5c014367948639800bf1b64208f19c7defc8f674

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne"
	cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi"
	cd "${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi"

	go get -d -v
	go build -tags noupgrade,noembeddocs \
		-ldflags "-X github.com/twpayne/chezmoi/cmd.DocsDir=$TERMUX_PREFIX/share/doc/chezmoi -X main.version=${TERMUX_PKG_VERSION}" .
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/chezmoi $TERMUX_PREFIX/bin/chezmoi

	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions \
		$TERMUX_PREFIX/share/fish/completions \
		$TERMUX_PREFIX/share/zsh/site-functions \
		$TERMUX_PREFIX/share/doc/chezmoi

	install ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/completions/chezmoi-completion.bash \
		$TERMUX_PREFIX/share/bash-completion/completions/chezmoi
	install ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/completions/chezmoi.fish \
		$TERMUX_PREFIX/share/fish/completions/chezmoi.fish
	install ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/completions/chezmoi.zsh \
		$TERMUX_PREFIX/share/zsh/site-functions/_chezmoi

	install ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/docs/{FAQ,HOWTO,QUICKSTART,REFERENCE,TEMPLATING}.md \
		$TERMUX_PREFIX/share/doc/chezmoi/
}
