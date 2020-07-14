# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="antijingoist"
GITHUB_PROJ="${PN%-bin}"
KEYWORDS="amd64 arm arm64 mips ppc ppc64 x86"

inherit font github-pkg

DESCRIPTION="Typeface that uses shapes & features to help offset visual symptoms of Dyslexia"

LICENSE="OFL"
SLOT="0"

if [[ ${PV} != "9999" ]]; then
	# You think you can parse upstream's version scheme into a valid SRC_URI using only bash?
	# Patches welcome.
	die "No."
fi

FONT_S="${S}/compiled"
FONT_SUFFIX="otf"
