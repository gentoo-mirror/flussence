# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_alpha/.alpha}"

DESCRIPTION="OSH is a bash-compatible shell."
HOMEPAGE="https://www.oilshell.org"
SRC_URI="${HOMEPAGE}/download/${MY_P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+readline"

RDEPEND="readline? ( sys-libs/readline:0 )"
DEPEND="${RDEPEND}
	|| (
		sys-libs/musl
		sys-libs/glibc[vanilla(-)]
	)"

S="${WORKDIR}/${MY_P}"

src_configure() {
	./configure --prefix="${EPREFIX}"/usr $(use_with readline) \
		|| die "configure failed: $?"
}