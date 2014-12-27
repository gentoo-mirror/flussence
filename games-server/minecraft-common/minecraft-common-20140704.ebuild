# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit games

DESCRIPTION="Common scripts for Minecraft servers"
HOMEPAGE="http://www.minecraft.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/openrc-0.12.4
	!!=games-server/minecraft-server-201*"

S="${WORKDIR}"

RUNTIME_DATA_DIR="/var/lib/minecraft"

src_prepare() {
	cp "${FILESDIR}"/init.sh . || die
	sed -i "s/@GAMES_USER_DED@/${GAMES_USER_DED}/g" init.sh || die
}

src_install() {
	diropts -o "${GAMES_USER_DED}" -g "${GAMES_GROUP}"
	keepdir "${RUNTIME_DATA_DIR}"
	gamesperms "${D}${RUNTIME_DATA_DIR}"

	newinitd init.sh minecraft-server

	prepgamesdirs
}

pkg_postinst() {
	ewarn "This package does nothing by itself. You need to install"
	ewarn "games-server/minecraft-server or games-server/craftbukkit."
	echo

	games_pkg_postinst
}
