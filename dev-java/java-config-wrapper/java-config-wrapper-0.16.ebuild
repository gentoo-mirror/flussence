# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Wrapper for java-config (PM-agnostic version)"
HOMEPAGE="http://www.gentoo.org/proj/en/java"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!<dev-java/java-config-1.3"
RDEPEND="
app-admin/eselect-package-manager
app-shells/bash
dev-java/javatoolkit
>=sys-apps/gentoo-functions-0.8
|| (
	(
		sys-apps/portage
		app-portage/portage-utils
	)
	sys-apps/paludis
)"

src_install() {
	dobin "${FILESDIR}"/java-1.5-fixer "${FILESDIR}"/java-check-environment src/shell/java-config
	dodoc AUTHORS

	exeinto /usr/lib/java-config-wrapper
	doexe "${FILESDIR}"/functions.sh
}
