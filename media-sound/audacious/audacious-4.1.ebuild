# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
fi

inherit meson xdg

LICENSE="BSD-2 BSD CC-BY-SA-4.0"
SLOT="0/5.3.0"

# libarchive is only (apparently) used for legacy winamp .wsz skins and nothing
# else at the moment. In the future it'll probably be used for playing media
# inside archives, but as that hasn't been coded at the time of writing there's
# no point having it on by default.
IUSE="+dbus gtk libarchive +qt5"
REQUIRED_USE="|| ( dbus gtk qt5 )"

QT_REQ="5.2:5="
RDEPEND="
	>=dev-libs/glib-2.32
	dbus? ( sys-apps/dbus )
	libarchive? ( app-arch/libarchive )
	gtk? (
		>=x11-libs/gtk+-2.24:2
		x11-libs/cairo
		x11-libs/pango
		virtual/libintl
	)
	qt5? (
		>=dev-qt/qtcore-${QT_REQ}
		>=dev-qt/qtgui-${QT_REQ}
		>=dev-qt/qtwidgets-${QT_REQ}
		virtual/freedesktop-icon-theme
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

src_configure() {
	local emesonargs=(
		"-Dauto_features=disabled"
		"$(meson_use dbus)"
		"$(meson_use gtk)"
		"$(meson_use libarchive)"
		"$(meson_use qt5 qt)"
	)
	meson_src_configure
}

pkg_preinst() {
	# make sure this matches, or else we'll create preserved-libs litter
	for audcore in "${D}"/usr/lib*/libaudcore.so."${SLOT##*/}"; do
		[ -e "$audcore" ] || eqawarn "Subslot in ebuild needs updating"
	done
}
