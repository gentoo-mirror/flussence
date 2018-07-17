# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="UT2004 Community Bonus Pack 2"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="mirror://ipfs/ipfs/QmdphFqmxmA4AVbfYXkX41e9Ad2VDEvR1WgHy57F5cbP3X -> cbp2-volume1_zip.zip
	mirror://ipfs/ipfs/QmV8H3Kf6LQDwfUB4EKfMAoW1bhmE6b3m3XNCcnpaMGGeD -> cbp2-volume2_zip.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="games-fps/ut2004-bonuspack-cbp1
	games-fps/ut2004-bonuspack-mega"

MY_DATADIR="/usr/share/games/ut2004"
S="${WORKDIR}"

src_prepare() {
	# Provided by ut2004-bonuspack-cbp1
	rm Music/Soeren.ogg
	# Provided by ut2004-bonuspack-mega
	rm Textures/Ty_RocketTextures.utx

	cd Help
	# Useless orphan file
	rm Note.txt
	mv GERROIDREADME.txt DOM-CBP2-Gerroid.txt
	mv Readme.txt CBP2-Readme.txt

	default
}

src_install() {
	local gamedirs=(Animations Help Maps Music StaticMeshes System Textures)

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
