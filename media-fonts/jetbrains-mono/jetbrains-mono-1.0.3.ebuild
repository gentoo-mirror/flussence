# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="The new monospaced font for JetBrains products"
HOMEPAGE="https://www.jetbrains.com/lp/mono/"
MY_P="JetBrainsMono-${PV}"
SRC_URI="https://github.com/JetBrains/JetBrainsMono/releases/download/v${PV}/${MY_P}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 mips ppc ppc64 s390 sh sparc x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}-Source"
FONT_SUFFIX="ttf"
FONT_S="${S}/${FONT_SUFFIX}"
