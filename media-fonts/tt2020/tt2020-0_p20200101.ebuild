# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="ctrlcctrlv"
GITHUB_PROJ="${PN^^}"
KEYWORDS="amd64 arm arm64 mips ppc ppc64 x86"

inherit font github-pkg

DESCRIPTION="Multilingual typewriter fonts with an organic appearance"

LICENSE="OFL"
SLOT="0"
IUSE="+minimal"

if [[ ${PV} != "9999" ]]; then
	EGIT_COMMIT="5aeea12e5b695d85f47a5cb577a560bc50696fb9"
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

S="${WORKDIR}/${GITHUB_PROJ}-${EGIT_COMMIT}"
FONT_S="${S}/dist"
FONT_SUFFIX="ttf"

src_configure() {
	use minimal || FONT_SUFFIX+=" woff2"
}
