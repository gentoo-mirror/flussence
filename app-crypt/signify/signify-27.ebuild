# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Cryptographically sign and verify files"
HOMEPAGE="https://github.com/aperezdc/signify"
SRC_URI="${HOMEPAGE}/releases/download/v${PV}/${P}.tar.xz"

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
