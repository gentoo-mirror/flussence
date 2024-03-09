# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fonts-ubuntu"
MY_PV="${PV/_p/-0ubuntu}"

DESCRIPTION="A set of matching libre/open fonts funded by Canonical"
HOMEPAGE="https://design.ubuntu.com/font/ https://launchpad.net/ubuntu-font-family"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/${MY_PN}/${MY_PV}/${MY_PN}_${PV/_p*}.orig.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV/_p*}"
LICENSE="UbuntuFontLicense-1.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 mips ppc ppc64 x86"

DOCS=( CONTRIBUTING.txt FONTLOG.txt README.txt )
FONT_SUFFIX="ttf"

inherit font
