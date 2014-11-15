# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games git-r3 cmake-utils

DESCRIPTION="A minecraft cartography tool"
HOMEPAGE="https://github.com/udoprog/c10t"
EGIT_REPO_URI="git://github.com/udoprog/c10t.git https://github.com/udoprog/c10t.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	sys-libs/zlib
	>=media-libs/libpng-1.2
	>=media-libs/freetype-2
	>=dev-libs/boost-1.46[threads]"
RDEPEND="${DEPEND}"

src_prepare() {
	# 2014-09-29 - this file tries to use std::cout/cerr without including <iostream> first
	epatch "${FILESDIR}/fix-nbt-iostream.patch"

	cmake-utils_src_prepare
}

# TODO: add an IUSE=tools to $(make nbt-inspect) and install that

src_install() {
	dogamesbin "${BUILD_DIR}/c10t"
}
