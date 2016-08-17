# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="FOSS software for video recording and live streaming"
HOMEPAGE="https://obsproject.com"
EGIT_REPO_URI="https://github.com/jp9000/obs-studio.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa fdk jack imagemagick pulseaudio +qt5 ssl truetype udev v4l +x264"

DEPEND="
	dev-libs/jansson
	sys-libs/zlib
	x11-libs/libxcb
	x11-libs/libXinerama
	x11-libs/libXrandr
	net-misc/curl
	sys-apps/dbus
	alsa? ( media-libs/alsa-lib )
	fdk? ( media-libs/fdk-aac )
	imagemagick? ( media-gfx/imagemagick )
	!imagemagick? ( virtual/ffmpeg )
	jack? ( media-sound/jack-audio-connection-kit )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	ssl? ( dev-libs/openssl:0 )
	truetype? (
		media-libs/fontconfig
		media-libs/freetype
	)
	udev? ( virtual/udev )
	v4l? ( media-libs/libv4l )
	x264? ( media-libs/x264 )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable alsa ALSA)
		$(cmake-utils_use_enable truetype FREETYPE)
		$(cmake-utils_use_enable pulseaudio PULSEAUDIO)
		$(cmake-utils_use_enable qt5 UI)
		$(cmake-utils_use_enable ssl SSL)
		$(cmake-utils_use_disable fdk LIBFDK)
		$(cmake-utils_use_disable jack JACK)
		$(cmake-utils_use_find_package imagemagick ImageMagick)
		$(cmake-utils_use_find_package udev LibUDev)
		$(cmake-utils_use_find_package v4l Libv4l2)
		$(cmake-utils_use_find_package x264 Libx264)
	)

	cmake-utils_src_configure
}
