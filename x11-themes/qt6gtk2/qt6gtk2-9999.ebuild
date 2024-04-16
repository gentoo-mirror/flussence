# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="trialuser02"

DESCRIPTION="GTK+2.0 integration plugins for Qt6"
LICENSE="GPL-2"
SLOT="0"

inherit github-pkg qmake-utils

if [[ "${PV}" != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="dev-qt/qtbase:6= x11-libs/gtk+:2 x11-libs/libX11"
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
