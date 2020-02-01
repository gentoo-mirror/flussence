# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/s/S}"

inherit font

DESCRIPTION="Unicode font for Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="http://users.teilar.gr/~g1951d/"
SRC_URI="http://users.teilar.gr/~g1951d/${MY_PN}.zip -> ${P}.zip doc? ( http://users.teilar.gr/~g1951d/${MY_PN}.pdf -> ${P}.pdf )"

LICENSE="Unicode_Fonts_for_Ancient_Scripts"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="doc"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_SUFFIX="ttf"

src_install() {
	if use doc; then
		DOCS="${DISTDIR}/${P}.pdf"
	fi

	font_src_install
}