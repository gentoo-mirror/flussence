# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${P/-bin/}

DESCRIPTION="Free-licensed standalone data file for playing Doom 1&2 deathmatch"
HOMEPAGE="https://freedoom.github.io/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip !games-fps/freedoom"
RDEPEND="${DEPEND}"

MY_DATADIR="/usr/share/games/doom"
S="${WORKDIR}/${MY_P}"

src_install() {
	insinto ${MY_DATADIR}
	doins *.wad
	dodoc CREDITS README.html
}

pkg_postinst() {
	elog "Note: This package only installs ${MY_DATADIR}/freedm.wad"
	elog "If you want offline-playable content, install games-fps/freedoom-bin."
}
