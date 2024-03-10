# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="RocketMan"
GITHUB_PROJ="slim-nimbus"

DESCRIPTION="Variant of the OpenIndiana theme with slim window borders and Gtk4 support"
LICENSE="GPL-2"
SLOT="0"

inherit autotools github-pkg xdg

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# Gtk3/4 themes are just inert files (CSS and images), deps not needed
DEPEND="x11-libs/gtk+:2"
RDEPEND="
	${DEPEND}
	virtual/freedesktop-icon-theme"
BDEPEND="
	>=dev-util/intltool-0.23
	>=x11-misc/icon-naming-utils-0.8.1
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
