# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit games

DESCRIPTION="Free-licensed alternatives to the Doom 1 and 2 IWAD data files"
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

	elog "This package only provides the freedoom1.wad and freedoom2.wad data files, which are"
	elog "installed in ${GAMES_DATADIR}/doom-data/. You also need a game engine; try"
	elog "games-fps/odamex or games-fps/chocolate-doom (other options are available)."
	echo
	ewarn "There has been some file reorganisation from previous versions in order to not clash"
	ewarn "with the commercial IWAD filenames. If you're upgrading, watch out for broken symlinks."
	echo
	einfo "This doesn't install freedm.wad; you can find it in games-fps/freedm."
}
