# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="GNOME Character Map, based on the Unicode Character Database"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"
SRC_URI="mirror://gnome/sources/gucharmap/${PV}/${P}.tar.bz2"

LICENSE="GPL-3 unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gconf"

DEPEND="
	!gnome-extra/gucharmap:2.90
	>=dev-libs/glib-2.16.3
	>=x11-libs/gtk+-2.14.0:2
	gconf? ( gnome-base/gconf:2 )"
RDEPEND="${DEPEND}"

src_configure() {
	econf --with-gtk=2.0 \
	      --disable-scrollkeeper \
	      $(use_enable gconf)
}
