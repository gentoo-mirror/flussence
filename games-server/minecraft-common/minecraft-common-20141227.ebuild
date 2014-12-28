# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit user

DESCRIPTION="Common scripts for Minecraft servers"
HOMEPAGE="http://www.minecraft.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/openrc-0.12.4
	!!=games-server/minecraft-server-201*"

# We don't have a source tarball, so the default $S doesn't exist.
# Default src_install expects to be able to cd to it though.
S="${WORKDIR}"

pkg_setup() {
	enewgroup minecraft-server
	enewuser minecraft-server -1 -1 /dev/null minecraft-server
}

src_install() {
	diropts -o minecraft-server -g minecraft-server
	keepdir /var/lib/minecraft

	newinitd "${FILESDIR}"/init.sh minecraft-server
}

pkg_postinst() {
	einfo "This package does nothing by itself. You need to install"
	einfo "games-server/minecraft-server or games-server/craftbukkit."
	echo
	ewarn "From version 20141227 onwards, this package defaults to user/group"
	ewarn "'minecraft-server' instead of 'games'. If upgrading, you'll need to"
	ewarn "fix the permissions yourself. An example for the default setup:"
	ewarn "    rc-service minecraft-server stop"
	ewarn "    chown -R minecraft-server: /var/lib/minecraft"
	ewarn "    rc-service minecraft-server start"
}
