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
	eapply -p2 "${FILESDIR}/${PN}.patch"
	eapply_user
}
