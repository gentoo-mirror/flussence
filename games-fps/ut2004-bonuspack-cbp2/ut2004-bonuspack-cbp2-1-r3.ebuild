# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ut2004-mod

DESCRIPTION="UT2004 Community Bonus Pack 2 Volume 1 and 2"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="mirror://ipfs/ipfs/QmdphFqmxmA4AVbfYXkX41e9Ad2VDEvR1WgHy57F5cbP3X -> cbp2-volume1_zip.zip
	mirror://ipfs/ipfs/QmV8H3Kf6LQDwfUB4EKfMAoW1bhmE6b3m3XNCcnpaMGGeD -> cbp2-volume2_zip.zip"

LICENSE="free-noncomm all-rights-reserved"

RDEPEND="
	games-fps/ut2004-bonuspack-cbp1
	games-fps/ut2004-bonuspack-mega"

src_prepare() {
	default

	# Provided by ut2004-bonuspack-cbp1
	rm Music/Soeren.ogg || die
	# Provided by ut2004-bonuspack-mega
	rm Textures/Ty_RocketTextures.utx || die

	# Useless orphan file
	rm Help/Note.txt || die
	cd Help || die
	mv Readme.txt CBP2-Readme.txt || die
	mv GERROIDREADME.txt DOM-CBP2-Gerroid.txt || die
	mv Tydal.txt DM-CBP2-Tydal.txt || die
}
