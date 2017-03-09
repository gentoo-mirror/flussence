# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="tint2 is a lightweight panel/taskbar for Linux."
HOMEPAGE="https://gitlab.com/o9000/tint2"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/o9000/tint2.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/o9000/${PN}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"
	inherit vcs-snapshot
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="battery examples svg startup-notification tint2conf"

DEPEND="
	dev-libs/glib:2
	svg? ( gnome-base/librsvg:2 )
	>=media-libs/imlib2-1.4.2[X,png]
	x11-libs/cairo
	x11-libs/pango[X]
	tint2conf? ( x11-libs/gtk+:2 )
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.3
	x11-libs/libXrender
	startup-notification? ( x11-libs/startup-notification )
	"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs+=(
		-DENABLE_BATTERY=$(usex battery)
		-DENABLE_EXTRA_THEMES=$(usex examples)
		-DENABLE_RSVG=$(usex svg)
		-DENABLE_SN=$(usex startup-notification)
		-DENABLE_TINT2CONF=$(usex tint2conf)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
