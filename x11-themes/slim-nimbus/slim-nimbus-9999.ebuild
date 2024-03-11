# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="RocketMan"
GITHUB_PROJ="slim-nimbus"

DESCRIPTION="Variant of the OpenIndiana theme with slim window borders and Gtk4 support"
LICENSE="GPL-2"
SLOT="0"

inherit autotools github-pkg xdg

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# Gtk3/4 themes are just inert files (CSS and images), deps not needed
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

pkg_postinst() {
	einfo "To set ${PN} as your desktop-wide GTK theme:"
	einfo " - GTK+ 2: edit ~/.gtkrc-2.0 and set gtk-theme-name=\"${PN}\""
	einfo " - Newer versions: edit ~/.config/gtk-X.0/settings.ini or use dconf-editor"
	if has_version gui-libs/gtk; then
		ewarn "Gtk4 requires a patched libadwaita to use custom themes."
		ewarn "You can obtain the patch here (put in /etc/portage/patches/gui-libs/libadwaita/):"
		ewarn "https://aur.archlinux.org/packages/libadwaita-without-adwaita-git"
	fi
}
