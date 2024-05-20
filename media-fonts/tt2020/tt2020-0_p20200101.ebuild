# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="ctrlcctrlv"
GITHUB_PROJ="${PN^^}"

DESCRIPTION="Multilingual typewriter fonts with an organic appearance"
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="+minimal"

inherit font github-pkg

if [[ ${PV} != "9999" ]]; then
	EGIT_COMMIT="5aeea12e5b695d85f47a5cb577a560bc50696fb9"
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${GITHUB_PROJ}-${EGIT_COMMIT}"
fi

FONT_S="${S}/dist"
FONT_SUFFIX="ttf"

src_configure() {
	use minimal || FONT_SUFFIX+=" woff2"
}
