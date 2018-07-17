# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="UT2004 Community Bonus Pack 1"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="mirror://ipfs/ipfs/QmX2WjFtWdhf87GR5g6UrkQhE8qKtVnhpeDkrW7Z3NpFDv -> cbp1.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"

MY_DATADIR="/usr/share/games/ut2004"
S="${WORKDIR}"

src_install() {
	local gamedirs=(Help Maps Music StaticMeshes Textures)

	insinto ${MY_DATADIR}

	for destdir in "${gamedirs[@]}"; do
		doins -r ./"${destdir}"
		ut2004_mod_link_files "${destdir}"
	done
}

# Files need to be symlinked to game dirs for the game to find them
ut2004_mod_link_files() {
	local destdir=$1
	local linkdirs=(/opt/ut2004 /opt/ut2004-ded)

	for srcfile in "${D}/${MY_DATADIR}/${destdir}"/*; do
		for linkdest in "${linkdirs[@]}"; do
			dosym "${srcfile}" "${linkdest}/${destdir}/${srcfile##*/}"
		done
	done
}
