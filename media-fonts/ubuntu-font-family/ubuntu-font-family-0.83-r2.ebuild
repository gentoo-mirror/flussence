# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6 # restricted by font.eclass

inherit font

DESCRIPTION="A set of matching libre/open fonts funded by Canonical"
HOMEPAGE="https://design.ubuntu.com/font/"
SRC_URI="https://assets.ubuntu.com/v1/0cef8205-${P}.zip -> ${P}.zip"

LICENSE="UbuntuFontLicense-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

DOCS=( CONTRIBUTING.txt FONTLOG.txt README.txt )
