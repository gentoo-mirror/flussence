# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper

MY_P=(
	dedicatedserver3339-bonuspack.zip
	ut2004-lnxpatch3369-2.tar.bz2
	ut2004-v3369-3-linux-dedicated.7z
)
DESCRIPTION="Unreal Tournament 2004 Linux Dedicated Server"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="
	mirror://ipfs/ipfs/QmYM5AnzgZFWHgPB17rHn7Ayxq8SqC2MD5rLZxAohaZkZ8 -> ${MY_P[0]}
	mirror://ipfs/ipfs/QmaaQUGbUAx1nJTuoGmmsX9Vmw55BCfRPq3v3SQuo66c8p -> ${MY_P[1]}
	mirror://ipfs/ipfs/QmUe7zL7umztdNrmoNSMB6EFX4WHJWJfzxuCcqn1ZM7PhP -> ${MY_P[2]}"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror strip"

DEPEND="app-arch/unzip
	app-arch/p7zip"
RDEPEND="sys-libs/glibc
	games-fps/ut2004-bonuspack-ece
	games-fps/ut2004-bonuspack-mega"

S=${WORKDIR}
dir=/opt/${PN}

src_prepare() {
	cp -rf UT2004-Patch/* . || die
	rm -rf System/{ucc-bin*,ut2004-bin*,*.dll,*.exe} UT2004-Patch
	if use amd64 ; then
		mv -f ut2004-ucc-bin-09192008/ucc-bin-linux-amd64 System/ucc-bin || die
	else
		mv -f ut2004-ucc-bin-09192008/ucc-bin System/ || die
	fi
	rm -rf ut2004-ucc-bin-09192008
	# Owned by ut2004-bonuspack-ece
	rm -f Animations/{MetalGuardAnim,ONSBPAnimations,NecrisAnim,MechaSkaarjAnims}.ukx
	rm -f Help/BonusPackReadme.txt
	rm -f Maps/{ONS-Adara,ONS-IslandHop,ONS-Tricky,ONS-Urban}.ut2
	rm -f Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax
	rm -f StaticMeshes/{HourAdara,BenMesh02,BenTropicalSM01,ONS-BPJW1,PC_UrbanStatic}.usx
	rm -f System/{ONS-IslandHop,ONS-Tricky,ONS-Adara,ONS-Urban,OnslaughtBP}.int
	rm -f System/xaplayersl3.upl
	rm -f Textures/{ONSBPTextures,BonusParticles,HourAdaraTexor,BenTex02,BenTropical01,PC_UrbanTex,AW-2k4XP,ONSBP_DestroyedVehicles,UT2004ECEPlayerSkins,CicadaTex,Construction_S}.utx
	# Owned by ut2004-bonuspack-mega
	rm -f System/{Manifest.ini,Manifest.int,Packages.md5}
}

src_install() {
	insinto "${dir}"
	doins -r ./*
	fperms +x "${dir}"/System/ucc-bin

	make_wrapper ut2004-ded "./ucc-bin server" "${dir}"/System
}

pkg_postinst() {
	einfo "You should take the time to edit the default server INI."
	einfo "Consult the INI Reference at http://www.unrealadmin.org/"
	einfo "for assistance in adjusting the following file:"
	einfo "${dir}/System/Default.ini"

	ewarn "To have your server authenticate properly to the"
	ewarn "central server, you MUST visit the following site"
	ewarn "and request a key. This is not required if you"
	ewarn "want an unfindable private server. [DoUplink=False]"
	ewarn "http://unreal.epicgames.com/ut2004server/cdkey.php"
}
