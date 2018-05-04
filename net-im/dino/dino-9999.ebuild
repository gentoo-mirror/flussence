# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"
VALA_MIN_API_VERSION="0.34"
inherit cmake-utils gnome2-utils vala

DESCRIPTION="Modern Jabber/XMPP Client using GTK+/Vala"
HOMEPAGE="https://dino.im"
MY_REPO_URI="https://github.com/dino/dino"

LICENSE="GPL-3"
SLOT="0"
IUSE="+gnupg +http +omemo"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${MY_REPO_URI}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="${MY_REPO_URI}/archive/${PV}.tar.gz"
fi

RDEPEND="dev-db/sqlite:3
	dev-libs/glib
	>=dev-libs/libgee-0.10
	net-libs/glib-networking
	>=x11-libs/gtk+-3.22:3
	gnupg? ( app-crypt/gpgme )
	http? ( net-libs/libsoup )
	omemo? ( dev-libs/libgcrypt:0 )"
DEPEND="$(vala_depend)
	${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	# this is dumb but setting -DPLUGINS didn't work
	# shellcheck disable=SC2207
	local disabled_plugins=(
		$(usex gnupg "" "openpgp")
		$(usex omemo "" "omemo")
		$(usex http  "" "http-files")
	)
	local mycmakeargs+=(
		"-DDISABLED_PLUGINS=$(local IFS=";"; echo "${disabled_plugins[*]}")"
	)
	cmake-utils_src_configure
}

update_caches() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
