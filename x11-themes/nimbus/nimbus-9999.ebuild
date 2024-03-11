# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="OpenIndiana"

DESCRIPTION="The default OpenIndiana theme (GTK+ 2.x/Gtk3 engine, icon- and metacity theme)"
LICENSE="GPL-2"
SLOT="0"

inherit autotools github-pkg xdg

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

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
