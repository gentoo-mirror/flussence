# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Lightweight Tox client"
HOMEPAGE="https://github.com/uTox/uTox/"
EGIT_REPO_URI="https://github.com/uTox/uTox.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus debug filter-audio"

# no idea if these are correct
RDEPEND="net-libs/tox[av]
	media-libs/freetype
	x11-libs/libX11
	dbus? ( sys-apps/dbus )
	filter-audio? ( media-libs/filter_audio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	mycmakeargs+=(
		-DENABLE_ASAN=$(usex debug)
		-DFILTER_AUDIO=$(usex filter-audio)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile \
		$(use dbus 'C_DEFINES="-DHAVE_DBUS"')
}
