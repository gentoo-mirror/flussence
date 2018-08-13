# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ut2004-mod.eclass
# @MAINTAINER:
# Anthony Parsons <ant+gentoo.bugs@flussence.eu>
# @AUTHOR:
# Anthony Parsons <ant+gentoo.bugs@flussence.eu>
# @BLURB: Common installer stuff for UT2004 mod files
# @DESCRIPTION: This provides a default src_install that takes care of putting files in the correct
# FHS folder, and also linking them to the /opt/ game folders so the game or server will find them.
# @SUPPORTED_EAPIS: 7

EXPORT_FUNCTIONS src_install

SLOT="0"
RESTRICT="mirror strip"
DEPEND="app-arch/unzip"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"

GAME_DATADIR="/usr/share/games/ut2004"
GAME_SUBDIRS=(Animations Help Maps Music Sounds StaticMeshes System Textures)
GAME_DESTDIRS=(/opt/ut2004 /opt/ut2004-ded)

ut2004-mod_src_install() {
	insinto "${GAME_DATADIR}"

	for subdir in "${GAME_SUBDIRS[@]}"; do
		[[ -d ./"${subdir}" ]] || continue
		doins -r ./"${subdir}"
		ut2004-mod_link_files "${subdir}"
	done
}

ut2004-mod_link_files() {
	local subdir=$1
	local linkdirs=(/opt/ut2004 /opt/ut2004-ded)

	for srcfile in "${D}/${GAME_DATADIR}/${subdir}"/*; do
		for optdir in "${GAME_DESTDIRS[@]}"; do
			dosym "${srcfile}" "${optdir}/${subdir}/${srcfile##*/}"
		done
	done
}
