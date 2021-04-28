# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library to play Commodore 64 music"
HOMEPAGE="https://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="mirror://sourceforge/sidplay-residfp/${PN}/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/5"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx static-libs"

src_configure() {
	econf \
		"$(use_enable cpu_flags_x86_mmx mmx)" \
		"$(use_enable static-libs       static)"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
