# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Lightweight Tox client"
HOMEPAGE="https://github.com/uTox/uTox/"
EGIT_REPO_URI="https://github.com/uTox/uTox.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus debug filter_audio test"

# no idea if these are correct
RDEPEND="net-libs/tox[av]
	media-libs/freetype
	media-libs/libv4l
	media-libs/openal
	x11-libs/libX11
	dbus? ( sys-apps/dbus )
	filter_audio? ( media-libs/filter_audio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( >=dev-libs/check-0.11.0 )"

src_configure() {
	mycmakeargs+=(
		-DENABLE_ASAN=$(usex debug)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_FILTERAUDIO=$(usex filter_audio)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_LTO=OFF # if you want this on as a user, use package.use+CFLAGS.
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	elog "${PN} requires x11-libs/gtk+:3 for a filepicker (setting avatar, sending files)."
}
