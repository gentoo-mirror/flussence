# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="OpenIndiana"
KEYWORDS="~amd64 ~x86"

inherit autotools github-pkg xdg

DESCRIPTION="The default OpenIndiana theme (GTK+ 2.x/Gtk3 engine, icon- and metacity theme)"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	x11-libs/gtk+:2
	x11-libs/gtk+:3"
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
