# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

MY_P=( ut2004-lnxpatch"${PV%.*}"-2.tar.bz2 ut2004-v"${PV/./-}"-linux-dedicated.7z )
DESCRIPTION="Editor's Choice Edition plus Mega Pack for the well-known first-person shooter"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="
	mirror://ipfs/ipfs/QmaaQUGbUAx1nJTuoGmmsX9Vmw55BCfRPq3v3SQuo66c8p -> ${MY_P[0]}
	mirror://ipfs/ipfs/QmUe7zL7umztdNrmoNSMB6EFX4WHJWJfzxuCcqn1ZM7PhP -> ${MY_P[1]}
"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	!games-server/ut2004-ded
	games-fps/ut2004-bonuspack-ece
	games-fps/ut2004-bonuspack-mega
	>=games-fps/ut2004-data-3186-r5
	media-libs/libsdl
	media-libs/openal
	sys-libs/glibc
	sys-libs/libstdc++-v3:5
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
"

BDEPEND="app-arch/p7zip"

S="${WORKDIR}/${PN^^}-Patch"
DIR="/opt/${PN}"

# The executable pages are required. Bug #114733.
QA_PREBUILT="*"

src_prepare() {
	default

	if use amd64; then
		mv System/"${PN}"-bin{-linux-amd64,} || die
		mv ../"${PN}"-ucc-bin-09192008/ucc-bin-linux-amd64 System/ucc-bin || die
	else
		rm System/"${PN}"-bin-linux-amd64 || die
		mv ../"${PN}"-ucc-bin-09192008/ucc-bin System/ucc-bin || die
	fi

	# In ut2004-bonuspack-mega.
	rm System/{Manifest.in[it],Packages.md5} || die
}

src_install() {
	insinto "${DIR}"
	doins -r .
	fperms +x "${DIR}"/System/{ucc,"${PN}"}-bin

	dosym ../../../usr/"$(get_libdir)"/libopenal.so "${DIR}"/System/openal.so
	dosym ../../../usr/"$(get_libdir)"/libSDL-1.2.so.0 "${DIR}"/System/libSDL-1.2.so.0

	make_wrapper "${PN}" ./"${PN}"-bin "${DIR}"/System "${DIR}"
	make_wrapper "${PN}"-ded "./ucc-bin server" "${DIR}"/System

	make_desktop_entry "${PN}" "Unreal Tournament 2004"
}

pkg_postinst() {
	# Here is where we check for the existence of a cdkey.
	# If we don't find one, we ask the user for it.
	if [[ -f "${EROOT}${DIR}"/System/cdkey ]] ; then
		einfo "A cdkey file is already present in ${EPREFIX}${DIR}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your cdkey."
	fi

	elog 'On OpenGL 2.1 graphics cards (virtually everything), the game supports'
	elog 'render-to-texture effects, but this is non-default and it lacks a GUI'
	elog 'option. To enable it, edit the following settings:'
	elog ' - In UT2004.ini or Default.ini, under "[OpenGLDrv.OpenGLRenderDevice]",'
	elog '   set "UseRenderTargets=True"'
	elog ' - In User.ini or DefUser.ini, under "[UnrealGame.UnrealPawn]",'
	elog '   set "bPlayerShadows=True" and "bBlobShadow=False"'
	elog 'The latter will make the Settings GUI say shadows are disabled, ignore it.'
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${EROOT}${DIR}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here so"
	ewarn "make sure you type it in correctly."
	ewarn "If you CTRL+C out of this, the game will not run!"
	ewarn
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
				echo "${CDKEY1^^}" > "${EROOT}${DIR}"/System/cdkey || die
				einfo "Thank you!"
				break
			else
				eerror "Your CD key entries do not match. Try again."
			fi
		fi
	done
}
