# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop go-module systemd xdg-utils

DESCRIPTION="A native Linux filesystem for Microsoft OneDrive."
HOMEPAGE="https://github.com/jstaf/onedriver"
SRC_URI="https://github.com/jstaf/onedriver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/foopsss/gentoo-overlay/releases/download/v${PV}/${P}-deps.tar.xz"

LICENSE="GPL-3 Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

# Tests require to be online, so they have to be restricted.
RESTRICT="test"

DEPEND="
	dev-lang/go
	dev-libs/json-glib
	net-libs/webkit-gtk:4.1
"
RDEPEND="
	systemd? (
		sys-apps/systemd
	)
	=sys-fs/fuse-2.9.9-r2
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-icon-path-change.patch
)

src_compile() {
	emake onedriver
	if use systemd; then
		emake onedriver-launcher
	fi
}

src_install() {
	dobin onedriver

	if use systemd; then
		dobin onedriver-launcher
		doicon pkg/resources/onedriver.svg
		doicon -s 128 pkg/resources/onedriver-128.png
		doicon -s 256 pkg/resources/onedriver.png
		domenu pkg/resources/onedriver-launcher.desktop
	fi

	systemd_douserunit pkg/resources/onedriver@.service
	doman pkg/resources/onedriver.1
	dodoc README.md
}

pkg_postinst() {
	if use systemd; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
	mandb

	elog "This version of onedriver does not yet support shared items"
	elog "or Microsoft SharePoint. Moreover, mounting the filesystem"
	elog "from the GUI and on log-in currently requires systemd."
	elog ""
	elog "However, the filesystem itself works with other init systems"
	elog "if mounted through the CLI."
	elog ""
	elog "See: https://github.com/jstaf/onedriver/issues/229."
}

pkg_postrm() {
	if use systemd; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
	mandb
}
