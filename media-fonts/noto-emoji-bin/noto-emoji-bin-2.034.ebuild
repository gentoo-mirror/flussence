# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="googlefonts"
GITHUB_PROJ="${PN%-bin}"

KEYWORDS="amd64 arm arm64 mips ppc ppc64 x86"

inherit font github-pkg

DESCRIPTION="Google Noto Color Emoji, upstream-prebuilt version"
HOMEPAGE="https://fonts.google.com/noto https://github.com/googlefonts/noto-emoji"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/v${PV}.tar.gz -> ${P/-bin/}.tar.gz"
	S="${WORKDIR}/${GITHUB_PROJ}-${PV}/fonts"
else
	die "No v9999 defined"
fi

LICENSE="OFL-1.1"
SLOT="0"

FONT_SUFFIX="ttf"
