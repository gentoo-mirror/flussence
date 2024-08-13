# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV^^}" # rc->RC
GITHUB_USER="dhewm"

DESCRIPTION="A cross-platform Doom 3 source port"
HOMEPAGE="https://dhewm3.org"
S="${WORKDIR}/${PN}-${MY_PV}/neo"
LICENSE="GPL-3"
SLOT="0"

inherit cmake github-pkg

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	media-libs/libjpeg-turbo
	media-libs/libogg
	>=media-libs/libsdl2-2.0.12
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
"
RDEPEND="${DEPEND}"
