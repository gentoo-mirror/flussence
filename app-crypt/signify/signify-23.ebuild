# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Cryptographically sign and verify files"
HOMEPAGE="https://github.com/aperezdc/signify"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/libbsd-0.8"
RDEPEND="${DEPEND}"

src_configure() {
	tc-export CC
}

src_install() {
	DESTDIR="${D}" PREFIX="/usr" emake install
}
