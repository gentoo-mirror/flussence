# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit games java-pkg-2

# name the ebuild version e.g. "1433" for snapshot 14w33, "1450c" for 14w50c
if [[ ${PV} == [0-9][0-9][0-9][0-9]* ]]; then
	MY_PV="${PV:0:2}w${PV:2:3}"
else
	MY_PV=${PV}
fi
MY_BASEURI="http://s3.amazonaws.com/Minecraft.Download/versions"

DESCRIPTION="Official dedicated server for Minecraft"
HOMEPAGE="http://www.minecraft.net"
SRC_URI="${MY_BASEURI}/${MY_PV}/minecraft_server.${MY_PV}.jar -> ${PN}-${MY_PV}.jar"
LICENSE="Minecraft-clickwrap-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6"
RESTRICT="mirror"

DEPEND=""
RDEPEND=">=virtual/jre-1.6
	games-server/minecraft-common"

S="${WORKDIR}"

pkg_setup() {
	ewarn "This package is NOT required if you want to run CraftBukkit."
	java-pkg-2_pkg_setup
	games_pkg_setup
}

src_unpack() {
	true # NOOP!
}

java_prepare() {
	cp "${FILESDIR}"/directory.sh . || die
	sed -i "s/@GAMES_USER_DED@/${GAMES_USER_DED}/g" directory.sh || die
}

src_install() {
	local ARGS
	use ipv6 || ARGS="-Djava.net.preferIPv4Stack=true"

	java-pkg_newjar "${DISTDIR}/${PN}-${MY_PV}.jar"
	java-pkg_dolauncher "${PN}" -into "${GAMES_PREFIX}" -pre directory.sh \
		--java_args "-Xmx1024M -Xms512M ${ARGS}" --pkg_args "nogui" \
		--main net.minecraft.server.MinecraftServer

	prepgamesdirs
}

pkg_postinst() {
	einfo "You may run ${PN} as a regular user or start a system-wide"
	einfo "instance using /etc/init.d/${PN}. The multiverse files are"
	einfo "stored in ~/.minecraft/servers or /var/lib/minecraft respectively."
	echo
	einfo "This package allows you to start multiple Minecraft server instances."
	einfo "You can do this by adding a multiverse name after ${PN} or by"
	einfo "creating a symlink such as /etc/init.d/${PN}.foo. The default"
	einfo "multiverse name is \"main\"."
	echo

	if has_version games-server/craftbukkit; then
		ewarn "You already have CraftBukkit installed. You may run both this and the"
		ewarn "official server against the same multiverse but not simultaneously."
		ewarn "This is not recommended though so don't come crying to us if it"
		ewarn "trashes your world."
		echo
	fi

	games_pkg_postinst
}
