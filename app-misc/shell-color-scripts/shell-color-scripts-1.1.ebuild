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
	eapply_user

	sed -i 's!/opt/shell-color-scripts/colorscripts!/usr/libexec/shell-color-scripts/colorscripts!' colorscript.sh || die "Sed failed!"
	sed -i 's!/opt/shell-color-scripts/colorscripts!/usr/libexec/shell-color-scripts/colorscripts!' completions/_colorscript || die "Sed failed!"
	sed -i 's!/opt/shell-color-scripts/colorscripts!/usr/libexec/shell-color-scripts/colorscripts!' completions/colorscript.fish || die "Sed failed!"

	rm Makefile
}

src_install() {
	install -Dm755 completions/_colorscript ${D}/usr/share/zsh/_colorscript
	install -Dm755 completions/colorscript.fish ${D}/usr/share/fish/vendor_completions.d/colorscript.fish
	install -Dm755 colorscripts/* -t ${D}/usr/libexec/shell-color-scripts/colorscripts
	install -Dm755 colorscript.sh ${D}/usr/bin/colorscript
	install -Dm644 colorscript.1 ${D}/usr/share/man/man1/colorscript.1
}
