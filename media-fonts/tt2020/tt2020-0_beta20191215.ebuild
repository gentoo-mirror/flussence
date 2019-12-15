# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Multilingual typewriter fonts with an organic appearance"
HOMEPAGE="https://fontlibrary.org/en/font/tt2020-base-style"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

BASE_URI="https://fontlibrary.org/assets/downloads/tt2020"
SRC_URI="
	${BASE_URI}-base-style/0281c4cc0e06b2e87f61042cbc95e0b9/tt2020-base-style.zip
	!minimal? (
		${BASE_URI}-style-b/2f708c85f33a9b885d409cfb06dd9fd7/tt2020-style-b.zip
		${BASE_URI}-style-d/c0dcbca529c8b7c092535332c0952d3c/tt2020-style-d.zip
		${BASE_URI}-style-e/95059d83e13f57668cd5982910906ffa/tt2020-style-e.zip
		${BASE_URI}-style-f/f84a17ee65b2d43475dda23f711a9926/tt2020-style-f.zip
		${BASE_URI}-style-g/c53821987454766300494f38ec7bad19/tt2020-style-g.zip
	)"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="INFO-*.txt"

src_unpack() {
	unpack "tt2020-base-style.zip"

	# These zips are a pain to unpack, mixed formats and clobbering filenames.
	use minimal && return

	FONT_SUFFIX+=" otf"

	mkdir tmp
	cd tmp || die
	for style in b d e f g; do
		unpack tt2020-style-"${style}".zip
		mv INFO.txt ../INFO-"${style}".txt
		for fontfile in TT_?.[ot]tf; do
			mv "${fontfile}" ../TT2020-"${style^}"."${fontfile##*.}"
		done
	done
}
