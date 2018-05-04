# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls +gtk qt5"

RDEPEND=">=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	virtual/freedesktop-icon-theme
	gtk? ( x11-libs/gtk+:2 )
	qt5? ( dev-qt/qtcore:5
	      dev-qt/qtgui:5
	      dev-qt/qtwidgets:5 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

PDEPEND="~media-plugins/audacious-plugins-${PV}"

src_configure() {
	# Audacious is barely usable without DBus, therefore it's hardcoded here
	# but I'm open to making it optional if you can give a good use case for it
	econf \
		--enable-dbus \
		"$(use_enable nls)" \
		"$(use_enable gtk gtk)" \
		"$(use_enable qt5 qt)"
}

pkg_postinst() {
	if use gtk && use qt5; then
		einfo "You have enabled both GTK+ and Qt interfaces. To use the Qt"
		einfo "frontend, you need to start Audacious with the -Q flag"
	fi
}
