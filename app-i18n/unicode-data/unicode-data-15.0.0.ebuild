# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unicode data from unicode.org"
HOMEPAGE="https://www.unicode.org/ucd/"
SRC_URI="https://www.unicode.org/Public/zipped/${PV}/UCD.zip -> ${P}-UCD.zip
	https://www.unicode.org/Public/zipped/${PV}/Unihan.zip -> ${P}-Unihan.zip"
S="${WORKDIR}"
LICENSE="unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_unpack() {
	# Unihan.zip needs to be installed as-is (as a zip) for reverse deps
	# https://bugzilla.gnome.org/show_bug.cgi?id=768210
	unpack "${P}"-UCD.zip
}

src_install() {
	insinto /usr/share/"${PN}"
	doins -r "${S}"/*
	newins "${DISTDIR}/${P}"-Unihan.zip Unihan.zip
}
