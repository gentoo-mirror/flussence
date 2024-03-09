# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="robey"
GITHUB_PROJ="font-problems"

DESCRIPTION="Console and framebuffer fonts, including Bizcat"
HOMEPAGE="https://github.com/robey/font-problems
	https://robey.lag.net/2010/01/23/tiny-monospace-font.html
	https://robey.lag.net/2020/02/09/bizcat-bitmap-font.html"
LICENSE="CC-BY-4.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 mips ppc ppc64 x86"

FONT_S="${S}/fonts"
FONT_SUFFIX="psf"

inherit font github-pkg
