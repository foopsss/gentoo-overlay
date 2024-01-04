# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A CLI for the collection of terminal color scripts. Includes 50+ beautiful terminal color scripts."
HOMEPAGE="https://gitlab.com/dwt1/shell-color-scripts"
SRC_URI="https://gitlab.com/dwt1/shell-color-scripts/-/archive/master/${PN}-master.tar.gz"

S="${WORKDIR}/${PN}-master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
    sys-devel/make
    sys-devel/binutils
"

src_prepare() {
	rm Makefile
	mv colorscript.sh colorscript
	eapply_user
}

src_install() {
	dobin colorscript

	insopts -m 0755
	insinto /usr/share/zsh
	doins completions/_colorscript

	insopts -m 0755
	insinto /usr/share/fish/vendor_completions.d
	doins completions/colorscript.fish

	insopts -m 0755
	insinto /opt/shell-color-scripts/colorscripts
	doins -r colorscripts/*

	doman colorscript.1
	dodoc README.md
}

pkg_postinst() {
	mandb

	elog "shell-color-scripts includes shell completions for the Fish and Zsh shells."
	elog "A help page for the program can be read using 'colorscript -h' or 'man colorscript'."
	elog "All the colorscripts are installed to '/opt/shell-color-scripts/colorscripts'."
}

pkg_postrm() {
	mandb
}
