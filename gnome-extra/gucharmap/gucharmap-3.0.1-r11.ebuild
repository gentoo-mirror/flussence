# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNOME Character Map, based on the Unicode Character Database"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"
SRC_URI="mirror://gnome/sources/gucharmap/${PV}/${P}.tar.bz2"

LICENSE="GPL-3 unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gconf nls +system-unicode"

RDEPEND="
	>=dev-libs/glib-2.16.3
	>=x11-libs/gtk+-2.14.0:2
	gconf? ( gnome-base/gconf:2 )"
DEPEND="${RDEPEND}
	system-unicode? (
		>=dev-lang/perl-5.26.0
		<=app-i18n/unicode-data-11.0.0
	)"

PATCHES=( "${FILESDIR}"/unicode-11-defines.patch )

src_prepare() {
	default

	if use system-unicode; then
		cd -- "${S}"/gucharmap || die
		rm unicode-{blocks,names{,list},unihan,categories,scripts,versions}.h
		perl "${FILESDIR}"/gen-guch-unicode-tables.pl
	fi
}

src_configure() {
	econf --with-gtk=2.0 --disable-scrollkeeper "$(use_enable nls)" "$(use_enable gconf)"
}