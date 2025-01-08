# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="B00merang-Project"
GITHUB_PROJ="Windows-XP"

DESCRIPTION="Recreations of the Windows XP .msstyle-engine themes"
LICENSE="GPL-3"
SLOT="0"

inherit github-pkg optfeature

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/Windows-XP-${PV}"
fi

src_install() {
	einstalldocs
	insinto /usr/share/themes
	doins -r "Windows XP "*/
}

pkg_postinst() {
	optfeature_header "Themes for the following (not installed) packages are also provided:"
	optfeature "GTK+2" "x11-libs/gtk+:2"
	optfeature "Gtk+3" "x11-libs/gtk+:3"
	[[ ${PV} == 9999 ]] && optfeature "Gtk 4" "gui-libs/gtk:4"
	optfeature "Cinnamon" "gnome-extra/cinnamon"
	optfeature "GNOME 3" "gnome-base/gnome-shell"
	optfeature "Metacity" "x11-wm/metacity"
	optfeature "Unity (gentoo-unity7 overlay)" "unity-base/unity"
	optfeature "XFCE4" "xfce-base/xfwm4"
}
