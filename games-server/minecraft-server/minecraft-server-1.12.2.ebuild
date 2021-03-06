# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6 # restricted by java-pkg-2 (java-utils-2 (versionator))
inherit java-pkg-2

# snapshot versions are mangled: "1433" for snapshot 14w33, "1450c" for 14w50c
if [[ ${PV} == [0-9][0-9][0-9][0-9]* ]]; then
	MY_PV="${PV:0:2}w${PV:2:3}"
	SLOT="snapshot-${MY_PV}"
elif [[ ${PV} == *_pre* ]]; then
	MY_PV="${PV/_/-}"
	SLOT="snapshot-${MY_PV}"
else
	MY_PV="${PV}"
	SLOT="stable"
fi
MY_BASEURI="http://s3.amazonaws.com/Minecraft.Download/versions"

DESCRIPTION="Official dedicated server for Minecraft"
HOMEPAGE="http://www.minecraft.net"
SRC_URI="${MY_BASEURI}/${MY_PV}/minecraft_server.${MY_PV}.jar -> ${PN}-${MY_PV}.jar"
LICENSE="Minecraft-clickwrap-EULA"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6"
RESTRICT="mirror"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_unpack() {
	true # NOOP!
}

src_install() {
	local ARGS
	use ipv6 || ARGS="-Djava.net.preferIPv4Stack=true"

	java-pkg_newjar "${DISTDIR}/${PN}-${MY_PV}.jar"
	java-pkg_dolauncher "${PN}-${MY_PV}" -pre "${FILESDIR}"/directory.sh \
		--java_args "-Xmx1G -Xms1G ${ARGS}" --pkg_args "nogui" \
		--main net.minecraft.server.MinecraftServer
}
