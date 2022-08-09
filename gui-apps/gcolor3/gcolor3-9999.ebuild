# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Choose colors from the picker or the screen"
HOMEPAGE="https://gitlab.gnome.org/World/gcolor3"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/World/gcolor3.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://gitlab.gnome.org/World/${PN}/-/archive/v${PV}/${P/-/-v}.tar.bz2"
	S="${WORKDIR}/${P/-/-v}"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	x11-libs/gtk+:3
	gui-libs/libhandy
	dev-libs/libportal[gtk]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/glib
	dev-util/desktop-file-utils
	sys-devel/gettext
"
