# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Free-licensed alternatives to the Doom 1 and 2 IWAD data files"
HOMEPAGE="https://freedoom.github.io/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

MY_DATADIR="/usr/share/games/doom"

src_install() {
	insinto ${MY_DATADIR}
	doins *.wad
	dodoc CREDITS README.html
}

pkg_postinst() {
	elog "This package only installs these data files:"
	elog "    ${MY_DATADIR}/freedoom1.wad"
	elog "    ${MY_DATADIR}/freedoom2.wad"
	echo
	elog "To play these you'll also need a game engine - try games-fps/odamex or"
	elog "games-fps/chocolate-doom (other options are available)."
	echo
	elog "freedm.wad is in a separate package, games-fps/freedm."
}
