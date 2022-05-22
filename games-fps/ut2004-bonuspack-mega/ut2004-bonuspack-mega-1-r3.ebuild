# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ut2004-mod

DESCRIPTION="UT2004 Megapack - Megapack bonus pack"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
MY_P="ut2004megapack-linux.tar.bz2"
SRC_URI="mirror://ipfs/ipfs/QmXcU3L3yhq4aVBdP9Lx7Ego9vH63D5Kx1PouvTuh8orz4 -> ${MY_P}"

LICENSE="ut2003"
RESTRICT="bindist mirror"

src_prepare() {
	default

	mv -f UT2004MegaPack/* . || die
	rmdir UT2004MegaPack || die

	# Remove files in Megapack which are already installed
	rm -r Animations Speech Web || die

	rm Help/{ReadMePatch.int.txt,UT2004Logo.bmp} || die
	mv Help/BonusPackReadme.txt Help/MegapackReadme.txt || die

	rm Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2 || die
	rm Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax || die
	rm StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx || die

	# System
	rm System/{AL,AS-,B,b,C,D,E,F,G,I,L,O,o,S,s,U,V,W,X,x}* || die
	rm System/{ucc,ut2004}-bin || die
	rm System/{ucc,ut2004}-bin-linux-amd64 || die
	rm Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S,HourAdaraTexor,jwfasterfiles,ONSBP_DestroyedVehicles,ONSBPTextures,PC_UrbanTex,UT2004ECEPlayerSkins}.utx || die
}
