# Copyright 1999-2019 Gentoo Authors
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

inherit xdg

LICENSE="BSD-2 BSD CC-BY-SA-4.0"
SLOT="0/5.2"

# N.B. gtk2 support was removed in 4.0_beta1.
# This ebuild maintains it primarily for old git commits.
IUSE="+dbus gtk +qt5"
REQUIRED_USE="|| ( dbus gtk qt5 )" # audtool requires dbus, GUI requires qt5

GUI_DEPEND="x11-libs/cairo x11-libs/pango virtual/freedesktop-icon-theme"
RDEPEND="
	>=dev-libs/glib-2.32
	dbus? ( sys-apps/dbus )
	gtk? ( x11-libs/gtk+:2 ${GUI_DEPEND} )
	qt5? (
		>=dev-qt/qtcore-5.2:5
		>=dev-qt/qtgui-5.2:5
		>=dev-qt/qtwidgets-5.2:5
		${GUI_DEPEND}
	)"
DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	dbus? ( dev-util/gdbus-codegen )"
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
		"$(use_enable gtk gtk)" \
		"$(use_enable qt5 qt)"
}