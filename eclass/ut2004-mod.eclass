# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ut2004-mod.eclass
# @MAINTAINER:
# flussence <gentoo+bugs@flussence.eu>
# @AUTHOR:
# flussence <gentoo+bugs@flussence.eu>
# @BLURB: Common installer stuff for UT2004 mod files
# @DESCRIPTION:
# This fills out some default metadata and dependencies, and also provides a src_install that puts
# game files in the right place for the server to find it (/opt/ut2004).
# @SUPPORTED_EAPIS: 7

EXPORT_FUNCTIONS src_install

KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
SLOT="0"

BDEPEND="app-arch/unzip"
RDEPEND="|| ( games-fps/ut2004 games-server/ut2004-ded )"

S="${WORKDIR}"

ut2004-mod_src_install() {
	insinto "/opt/ut2004"
	doins -r *
}
