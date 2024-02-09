# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="dhewm"
KEYWORDS="~amd64 ~x86"

inherit cmake github-pkg

DESCRIPTION="A cross-platform Doom 3 source port"
HOMEPAGE="https://dhewm3.org"

MY_PV="${PV^^}" # rc->RC

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	media-libs/libjpeg-turbo
	media-libs/libogg
	>=media-libs/libsdl2-2.0.12
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}/neo"
