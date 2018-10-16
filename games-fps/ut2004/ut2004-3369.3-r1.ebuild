# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils multilib desktop

MY_P="ut2004-lnxpatch${PV%.*}-2.tar.bz2"
MY_P=( ut2004-lnxpatch"${PV%.*}"-2.tar.bz2 ut2004-v"${PV/./-}"-linux-dedicated.7z )
DESCRIPTION="Editor's Choice Edition plus Mega Pack for the well-known first-person shooter"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="
	mirror://ipfs/ipfs/QmaaQUGbUAx1nJTuoGmmsX9Vmw55BCfRPq3v3SQuo66c8p -> ${MY_P[0]}
	mirror://ipfs/ipfs/QmUe7zL7umztdNrmoNSMB6EFX4WHJWJfzxuCcqn1ZM7PhP -> ${MY_P[1]}"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"

DEPEND="app-arch/p7zip"
RDEPEND="!games-server/ut2004-ded
	~virtual/libstdc++-3.3
	games-fps/ut2004-bonuspack-ece
	games-fps/ut2004-bonuspack-mega
	games-fps/ut2004-data
	media-libs/libsdl
	media-libs/openal
	sys-libs/glibc
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext"

S=${WORKDIR}/UT2004-Patch
dir=/opt/${PN}

# The executable pages are required #114733
QA_PREBUILT="${dir:1}/System/ut2004-bin
	${dir:1}/System/ucc-bin"

src_prepare() {
	default

	cd "${S}"/System || die

	# These files are owned by ut2004-bonuspack-mega
	rm -f Manifest.in{i,t} Packages.md5 ucc-bin* || die

	if use amd64 ; then
		mv -f ut2004-bin-linux-amd64 ut2004-bin || die
	else
		rm -f ut2004-bin-linux-amd64 || die
	fi

	cd "${WORKDIR}"/ut2004-ucc-bin-09192008 || die
	if use amd64 ; then
		mv -f ucc-bin-linux-amd64 "${S}"/System/ucc-bin || die
	else
		mv -f ucc-bin "${S}"/System/ || die
	fi
}

src_install() {
	insinto "${dir}"
	doins -r ./*
	fperms +x "${dir}"/System/ucc-bin
	fperms +x "${dir}"/System/ut2004-bin

	dosym "${ED}/usr/$(get_libdir)"/libopenal.so "${dir}"/System/openal.so
	dosym "${ED}/usr/$(get_libdir)"/libSDL-1.2.so.0 "${dir}"/System/libSDL-1.2.so.0

	make_wrapper ut2004 ./ut2004 "${dir}"

	make_desktop_entry ut2004 "Unreal Tournament 2004"
}

pkg_postinst() {
	# Here is where we check for the existence of a cdkey...
	# If we don't find one, we ask the user for it
	if [[ -f ${dir}/System/cdkey ]] ; then
		einfo "A cdkey file is already present in ${dir}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your cdkey."
	fi
	elog "Starting with 3369, the game supports render-to-texture. To enable"
	elog "it, you will need the Nvidia drivers of at least version 7676 and"
	elog "you should edit the following:"
	elog 'Set "UseRenderTargets=True" in the "[OpenGLDrv.OpenGLRenderDevice]"'
	elog 'section of your UT2004.ini or Default.ini and set "bPlayerShadows=True"'
	elog 'and "bBlobShadow=False" in the "[UnrealGame.UnrealPawn]" section of'
	elog 'your User.ini or DefUser.ini.'
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${dir}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here so"
	ewarn "make sure you type it in correctly."
	ewarn "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXXX-XXXXX-XXXXX-XXXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read -r CDKEY1
		einfo "Please re-enter your CD key:"
		read -r CDKEY2
		if [[ -z ${CDKEY1} ]] || [[ -z ${CDKEY2} ]] ; then
			echo "You entered a blank CD key. Try again."
		else
			if [[ ${CDKEY1} -eq ${CDKEY2} ]] ; then
				echo "${CDKEY1}" | tr "[:lower:]" "[:upper:]" > "${dir}"/System/cdkey
				einfo "Thank you!"
				break
			else
				eerror "Your CD key entries do not match. Try again."
			fi
		fi
	done
}
