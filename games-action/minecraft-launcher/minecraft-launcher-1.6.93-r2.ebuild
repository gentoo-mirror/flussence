# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 xdg

DESCRIPTION="Official Java launcher for Minecraft"
HOMEPAGE="https://www.minecraft.net"
SRC_URI="https://launcher.mojang.com/v1/objects/eabbff5ff8e21250e33670924a0c5e38f47c840b/launcher.jar -> ${P}.jar
	https://launcher.mojang.com/download/minecraft-launcher.svg"

# The launcher and old versions of the game itself work fine on 32-bit x86
KEYWORDS="~amd64 ~x86"
LICENSE="Mojang"
SLOT="legacy"

RESTRICT="bindist mirror"

RDEPEND="
	media-libs/openal
	virtual/opengl
	>=virtual/jre-1.8"

S="${WORKDIR}"

src_unpack() {
	# do not unpack jar file
	true
}

src_install() {
	java-pkg_newjar "${DISTDIR}/${P}.jar" "${PN}-${SLOT}.jar"
	java-pkg_dolauncher "${PN}-${SLOT}" --jar "${PN}-${SLOT}.jar" --java_args "\${JAVA_OPTS}" \
		-pre "${FILESDIR}/java-pkg-launcher.pre"

	# Could really use a raster icon here, but the old trick of using the hi-res mobile favicon from
	# the website no longer works (original URLs dead, new URLs 403 curl/wget without a fake UA)
	newicon -s scalable "${DISTDIR}/${PN}.svg" "${PN}-${SLOT}.svg"
	make_desktop_entry "${PN}-${SLOT}" "Minecraft (${SLOT})" "${PN}-${SLOT}"
}

pkg_postinst() {
	einfo "This package has installed the Java Minecraft launcher."
	einfo "To actually play the game, you need to purchase an account at:"
	einfo "    ${HOMEPAGE}"
}
