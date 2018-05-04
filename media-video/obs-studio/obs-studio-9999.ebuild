# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils multilib

DESCRIPTION="FOSS software for video recording and live streaming"
HOMEPAGE="https://obsproject.com"
MY_REPO_URI="https://github.com/jp9000/obs-studio"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${MY_REPO_URI}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="${MY_REPO_URI}/archive/${PV}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa fdk jack imagemagick libressl pulseaudio +qt5 ssl truetype udev v4l vlc"

DEPEND="
	dev-libs/jansson
	media-libs/x264
	net-misc/curl
	sys-apps/dbus
	sys-libs/zlib
	virtual/opengl
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libxcb
	alsa? ( media-libs/alsa-lib )
	fdk? ( media-libs/fdk-aac )
	imagemagick? ( media-gfx/imagemagick )
	!imagemagick? ( virtual/ffmpeg )
	jack? ( media-sound/jack-audio-connection-kit )
	ssl? (
		libressl? ( dev-libs/libressl )
		!libressl? ( dev-libs/openssl:0 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	truetype? (
		media-libs/fontconfig
		media-libs/freetype
	)
	udev? ( virtual/udev )
	v4l? ( media-libs/libv4l )
	vlc? ( media-video/vlc )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/bug-633596-workaround-for-"${PV}".patch )

src_configure() {
	local libdir
	libdir="$(get_libdir)"
	local mycmakeargs+=(
		"-DDISABLE_ALSA=$(usex !alsa)"
		"-DDISABLE_FREETYPE=$(usex !truetype)"
		"-DDISABLE_JACK=$(usex !jack)"
		"-DDISABLE_LIBFDK=$(usex !fdk)"
		"-DDISABLE_PULSEAUDIO=$(usex !pulseaudio)"
		"-DDISABLE_UDEV=$(usex !udev)"
		"-DDISABLE_UI=$(usex !qt5)"
		"-DDISABLE_V4L2=$(usex !v4l)"
		"-DDISABLE_VLC=$(usex !vlc)"
		"-DLIBOBS_PREFER_IMAGEMAGICK=$(usex imagemagick)"
		"-DUSE_SSL=$(usex ssl)"
		"-DOBS_MULTIARCH_SUFFIX=${libdir#lib}"
	)

	cmake-utils_src_configure
}
