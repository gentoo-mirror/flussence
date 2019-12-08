# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ut2004-mod

DESCRIPTION="UT2004 Editor's Choice Edition bonus pack"
HOMEPAGE="http://www.unrealtournament2004.com/"
MY_P=(ut2004megapack-linux.tar.bz2 UT2004-ONSBonusMapPack.zip)
SRC_URI="mirror://ipfs/ipfs/QmXcU3L3yhq4aVBdP9Lx7Ego9vH63D5Kx1PouvTuh8orz4 -> ${MY_P[0]}
	mirror://ipfs/ipfs/QmQCpjBGdMYof2yNF5cQHrQNSzjvGkXh15uZN2RbS1HJjz -> ${MY_P[1]}"

LICENSE="ut2003"
RESTRICT="bindist mirror"
IUSE=""

src_unpack() {
	unpack "${MY_P[0]}"
	cd UT2004MegaPack/Maps || die
	unpack "${MY_P[1]}" # bug #278002
}

src_prepare() {
	default

	mv -f UT2004MegaPack/* . || die
	rmdir UT2004MegaPack || die

	rm -r Music Speech || die

	# Remove megapack files which are not in ece
	rm Animations/ONSNewTank-A.ukx || die
	rm Help/ReadMePatch.int.txt || die
	# Help/{DebuggerLogo.bmp,InstallerLogo.bmp,Unreal.ico,UnrealEd.ico}
	# are not in megapack.
	# Keep new Help/UT2004Logo.bmp
	# Manual dir does not exist in megapack
	rm Maps/{AS*,CTF*,DM*} || die
	rm Sounds/A_Announcer_BP2.uax || die
	rm StaticMeshes/{JumpShipObjects.usx,Ty_RocketSMeshes.usx} || die
	rm System/{A*,b*,B*,CacheRecords.ucl} || die
	rm System/{*.det,*.est,*.frt,*.itt,*.kot} || die
	rm System/{CTF*,D*,Editor*,G*,I*,L*,Onslaught.*,*.md5} || die
	rm System/{u*,U*,V*,X*,Core.u,Engine.u,F*,*.ucl,Sk*} || die
	rm Textures/{J*,j*,T*} || die
	rm -r Web || die

	# The file lists of ut2004-3369-r1 and -r2 are identical
	# Remove files owned by ut2004-3369-r2
	rm Help/UT2004Logo.bmp || die
	# The 2 Manifest files have not changed
	rm System/{Manifest.in{i,t},OnslaughtFull.int} || die
	rm System/{Core.int,Engine.int,Setup.int,Window.int} || die
	rm System/{OnslaughtFull.u,OnslaughtBP.u} || die
}
