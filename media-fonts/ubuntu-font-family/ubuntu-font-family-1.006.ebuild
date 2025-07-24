# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="canonical"
GITHUB_PROJ="Ubuntu-Sans-fonts"

DESCRIPTION="A set of matching libre/open fonts funded by Canonical"
HOMEPAGE="https://design.ubuntu.com/font/ https://launchpad.net/ubuntu-font-family"

inherit font github-pkg

MY_P="UbuntuSans-fonts-${PV}"
MONO_P="UbuntuSansMono-fonts-${PV}"

SRC_URI="
	${GITHUB_HOMEPAGE}/releases/download/v${PV}/${MY_P}.zip
	${GITHUB_HOMEPAGE/${GITHUB_PROJ}/Ubuntu-Sans-Mono-fonts}/releases/download/v${PV}/${MONO_P}.zip"
S="${WORKDIR}"
FONT_S=("${S}/${MY_P}/variable" "${S}/${MONO_P}/variable")

LICENSE="UbuntuFontLicense-1.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

BDEPEND="app-arch/unzip"

DOCS=( "${MY_P}"/{CONTRIBUTING,FONTLOG,README}.txt )
FONT_SUFFIX="ttf"
