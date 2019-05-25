# Copyright 1999-2018 Gentoo Authors
# Copyright 2016-2019 Anthony Parsons
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3 autotools
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
fi

inherit xdg-utils

LICENSE="BSD-2"
SLOT="0"

IUSE="+dbus nls +gtk qt5"
REQUIRED_USE="|| ( dbus gtk qt5 )" # audtool requires dbus

GUI_DEPEND="x11-libs/cairo x11-libs/pango virtual/freedesktop-icon-theme"
RDEPEND=">=dev-libs/glib-2.30
	gtk? ( x11-libs/gtk+:2 ${GUI_DEPEND} )
	qt5? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 ${GUI_DEPEND} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dbus? ( dev-util/gdbus-codegen )
	nls? ( dev-util/intltool )"

PDEPEND="~media-plugins/audacious-plugins-${PV}"

pkg_setup() {
	if ! use dbus; then
		ewarn "You are building ${PN} without DBus support."
		ewarn "It'll run, but a lot of functionality won't work. Proceed at your own risk."
	fi
}

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	econf \
		"$(use_enable dbus)" \
		"$(use_enable nls)" \
		"$(use_enable gtk gtk)" \
		"$(use_enable qt5 qt)"
}

pkg_postinst() {
	if use gtk && use qt5; then
		einfo "You have enabled both GTK+ and Qt interfaces. To use the Qt"
		einfo "frontend, you need to start Audacious with the -Q flag"
	fi

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
