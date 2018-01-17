# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GNOME Character Map, based on the Unicode Character Database"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"
SRC_URI="mirror://gnome/sources/gucharmap/${PV}/${P}.tar.bz2"

LICENSE="GPL-3 unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gconf nls +system-unicode"

DEPEND="
	!gnome-extra/gucharmap:2.90
	>=dev-libs/glib-2.16.3
	>=x11-libs/gtk+-2.14.0:2
	gconf? ( gnome-base/gconf:2 )
	system-unicode? ( <=app-i18n/unicode-data-10.0.0 )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/unicode-10-defines.patch )

src_prepare() {
	default

	if use system-unicode; then
		cd -- "${S}"/gucharmap
		rm unicode-{blocks,names,nameslist,unihan,categories,scripts,versions}.h
		# N.B. gen-guch-unicode-tables.pl is absent from the 3.0.1 tarball. The version used here is
		# from gucharmap-10.0.0, with missing gtk2 header include lines restored, but otherwise
		# verbatim.
		perl "${FILESDIR}"/gen-guch-unicode-tables.pl \
			"$(best_version app-i18n/unicode-data)" \
			/usr/share/unicode-data
	fi
}

src_configure() {
	econf --with-gtk=2.0 \
		--disable-scrollkeeper \
		$(use_enable nls) \
		$(use_enable gconf)
}
