# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="UT2004 Megapack bonus pack"

inherit ut2004-mod

HOMEPAGE="http://www.unrealtournament2004.com/"
MY_P="ut2004megapack-linux.tar.bz2"
SRC_URI="mirror://ipfs/ipfs/QmXcU3L3yhq4aVBdP9Lx7Ego9vH63D5Kx1PouvTuh8orz4 -> ${MY_P}"

LICENSE="ut2003"
IUSE=""

src_prepare() {
	default

	mv -f UT2004MegaPack/* . || die
	rmdir UT2004MegaPack

	# Remove files in Megapack which are already installed by ut2004-bonuspack-ece
	rm -r Animations Speech Web

	rm Help/{ReadMePatch.int.txt,UT2004Logo.bmp}
	mv Help/BonusPackReadme.txt Help/MegapackReadme.txt

	rm Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2
	rm Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax
	rm StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx

	# System
	rm System/{AL,AS-,B,b,C,D,E,F,G,I,L,O,o,S,s,U,V,W,X,x}*
	rm System/{ucc,ut2004}-bin
	rm System/{ucc,ut2004}-bin-linux-amd64
	rm Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S,HourAdaraTexor,jwfasterfiles,ONSBP_DestroyedVehicles,ONSBPTextures,PC_UrbanTex,UT2004ECEPlayerSkins}.utx
}
