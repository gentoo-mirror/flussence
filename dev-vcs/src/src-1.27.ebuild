# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} ) # restricted by deps: asciidoc, pylint
inherit python-r1

DESCRIPTION="A svn/hg/git-like UI wrapper around RCS"
HOMEPAGE="http://www.catb.org/esr/src/"
SRC_URI="https://gitlab.com/esr/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="$PYTHON_REQUIRED_USE"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-vcs/rcs
	${PYTHON_DEPS}"
BDEPEND="
	app-text/asciidoc
	test? (
		dev-python/pylint[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	dodoc README TODO NEWS
}
