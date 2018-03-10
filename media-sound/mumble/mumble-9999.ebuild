# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 multilib qmake-utils

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://www.mumble.info"
EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"

LICENSE="BSD MIT CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa dbus debug g15 oss pch portaudio pulseaudio speech zeroconf"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/opus
	media-libs/speex
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	g15? ( app-misc/g15daemon )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	speech? ( app-accessibility/speech-dispatcher )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
	"
RDEPEND="${DEPEND}"

src_configure() {
	local qmake_conf=(
		$(usex alsa alsa no-alsa)
		$(usex debug debug release)
		$(usex g15 g15 no-g15)
		$(usex oss oss no-oss)
		$(usex portaudio portaudio no-portaudio)
		$(usex pulseaudio pulseaudio no-pulseaudio)
		$(usex speech speechd no-speechd)
		$(usex zeroconf bonjour no-bonjour)
		# Does not build with celt 0.11.3
		bundled-celt
		no-bundled-opus
		no-bundled-speex
		no-embed-qt-translations
		no-server
		no-update
	)

	eqmake5 -recursive main.pro \
		CONFIG+="${qmake_conf[*]}" \
		DEFINES+="PLUGIN_PATH=/usr/$(get_libdir)/mumble"
}

src_install() {
	local build_dir="$(usex debug debug release)"

	dobin "${build_dir}"/mumble

	into /usr/$(get_libdir)/mumble/
	dolib "${build_dir}"/lib*.so*
	dolib "${build_dir}"/plugins/lib*.so*
	into /usr

	doman man/mumble{,-overlay}.1

	domenu scripts/mumble.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins icons/mumble.svg

	insinto /usr/share/services
	doins scripts/mumble.protocol

	default
}
