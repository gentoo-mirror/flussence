# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GTK+2.0 integration plugins for Qt6"
HOMEPAGE="https://www.opencode.net/trialuser/qt6gtk2"
LICENSE="GPL-2+"
SLOT="0"

inherit qmake-utils

if [[ "${PV}" == 9999 ]]; then
	EGIT_SRC_URI="https://www.opencode.net/trialuser/qt6gtk2.git"
	inherit git-r3
else
	SRC_URI="https://www.opencode.net/api/v4/projects/5460/packages/generic/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND=">=dev-qt/qtbase-6.2.0:6=[dbus] x11-libs/gtk+:2 x11-libs/libX11"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake6 PREFIX="${EPREFIX}/usr"
	default
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	# don't leave users completely high and dry
	dodoc README.md
}
