# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A native Linux filesystem for Microsoft OneDrive."
HOMEPAGE="https://github.com/jstaf/onedriver"
SRC_URI="https://github.com/jstaf/onedriver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/foopsss/Ebuilds/releases/download/v${PV}/${P}-deps.tar.xz"

S="${WORKDIR}/${P}"

# GPL-3 is the license of onedriver.
# The licenses mentioned afterwards belong to the statically linked dependencies listed in go.mod.
LICENSE="GPL-3 Apache-2.0 BSD-2-Clause ISC BSD-3-Clause MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-gui"

# Restricting tests since they require to be run either online or as root.
RESTRICT="test"

DEPEND="
    =net-libs/webkit-gtk-2.38.5
    dev-libs/json-glib
"
RDEPEND="
    ${DEPEND}
    gui? (
	    sys-apps/systemd
    )
"
BDEPEND="
    virtual/pkgconfig
"

src_compile() {
	emake onedriver

	if use gui; then
		emake onedriver-launcher
	fi
}

src_install() {
	dobin onedriver

	if use gui; then
		dobin onedriver-launcher

		dodir /usr/share/icons/onedriver
		insinto /usr/share/icons/onedriver
		newins resources/onedriver.svg onedriver.svg
		newins resources/onedriver.png onedriver.png
		newins resources/onedriver-128.png onedriver-128.png

		insinto /usr/share/applications
		newins resources/onedriver.desktop onedriver.desktop
	fi

	insinto /etc/systemd/user
	newins resources/onedriver@.service onedriver@.service

	doman resources/onedriver.1
	dodoc README.md
}

pkg_config() {
	elog "Updating the manual pages index cache..."
	mandb
}

pkg_postinst() {
	elog "onedriver can be configured with a config file at '~/.config/onedriver/config.yml'."
	elog ""
	elog "It should be noted that this version of onedriver does not yet support shared items or Microsoft SharePoint."
	elog "Moreover, the GUI and 'mount-on-login' function only work with systemd as of now."
	elog "However, the filesystem itself works with other init systems, and the missing functionality could be added in the future."
	elog "For more information see: https://github.com/jstaf/onedriver/issues/229."
}
