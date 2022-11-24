# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 xdg

DESCRIPTION="Old official Java launcher for Minecraft"
HOMEPAGE="https://www.minecraft.net/"
MY_SHA1="eabbff5ff8e21250e33670924a0c5e38f47c840b"
SRC_URI="https://launcher.mojang.com/v1/objects/${MY_SHA1}/launcher.jar -> ${P/-legacy}.jar
	https://launcher.mojang.com/download/minecraft-launcher.svg"

# The launcher and old versions of the game itself work fine on 32-bit x86
KEYWORDS="~amd64 ~x86"
LICENSE="Mojang"
SLOT="legacy"

RESTRICT="bindist mirror"

# Minecraft uses its own bundled OpenAL et al, so no point listing them here. In the past there were
# attempts to override everything with OS-packaged versions (like steam-overlay tries to for that)
# but it was given up on. Prism Launcher has options to patch the game to use native OpenAL if you
# really want it.
RDEPEND="
	virtual/opengl
	>=virtual/jre-1.8"

S="${WORKDIR}"

src_unpack() {
	# do not unpack jar file
	true
}

src_install() {
	java-pkg_newjar "${DISTDIR}/${P/-legacy}.jar" "${PN}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" --java_args "\${JAVA_OPTS}" \
		-pre "${FILESDIR}/java-pkg-launcher.pre"

	# Could really use a raster icon here, but the old trick of using the hi-res mobile favicon from
	# the website no longer works (original URLs dead, new URLs 403 curl/wget without a fake UA)
	newicon -s scalable "${DISTDIR}/${PN/-legacy}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "Minecraft (${SLOT})" "${PN}"
}

pkg_postinst() {
	einfo "This package has installed the Java-based Minecraft launcher."
	einfo "If you don't already have a paid Mojang (pre-2021) Minecraft account, you"
	einfo "won't be able to do much with this, as new accounts use the MS Live account"
	einfo "system. In that case, use games-action/prismlauncher which can handle both."
	if ! has_version "virtual/jre:1.8"; then
		ewarn "Older versions of Minecraft may crash at startup with Java 9 or newer."
		ewarn "If you intend to use these, ensure you have virtual/jre:1.8 installed."
	fi
}
