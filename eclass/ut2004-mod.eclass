# Copyright 2018-2020 Anthony Parsons
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

KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
SLOT="0"

BDEPEND="app-arch/unzip"
RDEPEND="|| ( games-fps/ut2004 games-server/ut2004-ded )"

S="${WORKDIR}"

GAME_DATADIR="/opt/ut2004"
GAME_SUBDIRS=(Animations Help Maps Music Sounds StaticMeshes System Textures)

ut2004-mod_src_install() {
	insinto "${GAME_DATADIR}"
	doins -r *
}
