# Copyright 2018-2019 Anthony Parsons
# Distributed under the terms of the GNU General Public License v2

EAPI=6 # restricted by vcs-snapshot.eclass

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit vcs-snapshot python-r1

DESCRIPTION="A svn/hg/git-like UI wrapper around RCS"
HOMEPAGE="http://www.catb.org/esr/src/"
SRC_URI="https://gitlab.com/esr/${PN}/repository/archive.tar.bz2?ref=${PV} -> ${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="$PYTHON_REQUIRED_USE"

HDEPEND="app-text/asciidoc"
RDEPEND="dev-vcs/rcs"
DEPEND="test? (
	dev-python/pylint[${PYTHON_USEDEP}]
	${RDEPEND}
)"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	dodoc README TODO NEWS
}