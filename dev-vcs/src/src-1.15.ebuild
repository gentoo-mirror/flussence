# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit vcs-snapshot python-r1

DESCRIPTION="An RCS work-alike with svn/hg/git-like UI"
HOMEPAGE="http://www.catb.org/esr/src/"
SRC_URI="https://gitlab.com/esr/${PN}/repository/archive.tar.bz2?ref=${PV} -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="$PYTHON_REQUIRED_USE"

RDEPEND="dev-vcs/rcs"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	dodoc README TODO NEWS
}
