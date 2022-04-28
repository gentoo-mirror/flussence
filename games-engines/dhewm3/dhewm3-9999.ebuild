# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="dhewm"
KEYWORDS="~amd64 ~x86"

inherit cmake github-pkg

DESCRIPTION="A cross-platform Doom 3 source port"
HOMEPAGE="https://dhewm3.org"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	media-libs/libjpeg-turbo
	media-libs/libogg
	media-libs/libsdl2
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/neo"
