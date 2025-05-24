# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Collection of 50+ beautiful terminal color scripts."
HOMEPAGE="https://gitlab.com/dwt1/shell-color-scripts"

GIT_COMMIT="576735cf656ece1bfd314e617b91c0e9d486d262"
SRC_URI="https://gitlab.com/dwt1/shell-color-scripts/-/archive/${GIT_COMMIT}/${PN}-${GIT_COMMIT}.tar.bz2 -> ${P}-${PR}.tar.bz2"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-build/make
	sys-devel/binutils
"

src_prepare() {
	rm Makefile
	mv colorscript.sh colorscript
	eapply -p1 "${FILESDIR}/${PN}-hex-fix.patch"
	eapply_user
}

src_install() {
	dobin colorscript

	insopts -m 0755
	insinto /opt/shell-color-scripts/colorscripts
	doins -r colorscripts/*

	dofishcomp completions/colorscript.fish
	dozshcomp completions/_colorscript

	doman colorscript.1
	dodoc README.md
}

pkg_postinst() {
	mandb

	elog "shell-color-scripts includes shell completions for the Fish and Zsh shells."
	elog "A help page can be read using 'colorscript -h' or 'man colorscript'."
	elog "All the colorscripts are installed to '/opt/shell-color-scripts/colorscripts'."

	elog "This package offers a patched 'hex' color script to show DT's list of colours"
	elog "if the .Xresources file cannot be found. More information about the patch can"
	elog "be read on https://gitlab.com/dwt1/shell-color-scripts/-/merge_requests/36."
}

pkg_postrm() {
	mandb
}
