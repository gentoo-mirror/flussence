# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-bin/}

DESCRIPTION="Free-licensed alternatives to the Doom 1 and 2 IWAD data files"
HOMEPAGE="https://freedoom.github.io/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/${MY_P}.zip
	mirror://ipfs/ipfs/QmYtwYwLuu1bA92FZv5c2shViVg1NmJPYhmMGQwhx7M6a7 -> ${MY_P}.zip"

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
	doins ./*.wad
	dodoc CREDITS.txt README.html
}

pkg_postinst() {
	elog "This package only installs these data files:"
	elog "    ${MY_DATADIR}/freedoom1.wad"
	elog "    ${MY_DATADIR}/freedoom2.wad"
	echo
	elog "To play these you'll also need a game engine - try games-fps/odamex or"
	elog "games-fps/chocolate-doom (other options are available)."
	echo
	elog "freedm.wad is in a separate package, games-fps/freedm-bin."
	echo
	elog "This is the prebuilt data from upstream. If you'd rather build from"
	elog "source for whatever reason, try games-fps/freedoom::games-overlay."
}
