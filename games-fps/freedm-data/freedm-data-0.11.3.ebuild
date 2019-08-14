# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-data/}

DESCRIPTION="Free-licensed standalone data file for playing Doom 1&2 deathmatch"
HOMEPAGE="https://freedoom.github.io/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/${MY_P}.zip
	mirror://ipfs/ipfs/QmS8LLAe1JDx4qX4o3aM7LD7eoszmH6Yq8k3UCPRFJf4h2 -> ${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="app-arch/unzip"

MY_DATADIR="/usr/share/games/doom"
S="${WORKDIR}/${MY_P}"

src_install() {
	insinto ${MY_DATADIR}
	doins ./*.wad
	dodoc CREDITS.txt README.html
}

pkg_postinst() {
	elog "Note: This package only installs ${MY_DATADIR}/freedm.wad"
	elog "If you want offline-playable content, install ${CATEGORY}/${PN/freedm/freedoom}."
}
