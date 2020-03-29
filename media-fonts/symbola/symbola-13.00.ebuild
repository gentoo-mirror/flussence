# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Unicode font for Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="https://dn-works.com/ufas/"
MY_PN="${PN/s/S}"
SRC_URI="https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/${MY_PN}.zip -> ${P}.zip
	doc? ( https://dn-works.com/wp-content/uploads/2020/UFAS-Docs/${MY_PN}.pdf -> ${P}.pdf )"

LICENSE="Unicode_Fonts_for_Ancient_Scripts"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="doc"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_SUFFIX="otf"

src_install() {
	if use doc; then
		DOCS="${DISTDIR}/${P}.pdf"
	fi

	font_src_install
}
