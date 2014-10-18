# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit games

DESCRIPTION="Free-licensed standalone data file for playing Doom 1&2 deathmatch"
HOMEPAGE="https://freedoom.github.io/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto "${GAMES_DATADIR}/doom-data"
	doins *.wad
	dodoc COPYING CREDITS README.html
}

pkg_postinst() {
	games_pkg_postinst

	elog "This package only installs freedm.wad, the freedoom1/2 files are in games-fps/freedoom."
}
