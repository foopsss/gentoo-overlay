# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A CLI for the collection of terminal color scripts. Includes 50+ beautiful terminal color scripts."
HOMEPAGE="https://gitlab.com/dwt1/shell-color-scripts"
SRC_URI="https://gitlab.com/dwt1/shell-color-scripts/-/archive/master/${PN}-master.tar.gz"

S="${WORKDIR}/${PN}-master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/make"

src_prepare() {
	eapply -p1 "${FILESDIR}/${PN}.patch"
	eapply_user
}

src_install() {
	emake DESTDIR="${D}" install
	doman colorscript.1
	dodoc README.md
}

pkg_postinst() {
	elog "shell-color-scripts includes shell completions for the Fish and Zsh shells."
	elog "A help page for the program can be read using 'colorscript -h' or 'man colorscript'."
	elog "All the colorscripts are installed to '/usr/libexec/shell-color-scripts/colorscripts'."
}
