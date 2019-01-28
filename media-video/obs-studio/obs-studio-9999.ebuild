# Copyright 1999-2018 Gentoo Authors
# Copyright 2016-2019 Anthony Parsons
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )
inherit cmake-utils gnome2-utils python-single-r1

DESCRIPTION="FOSS software for video recording and live streaming"
HOMEPAGE="https://obsproject.com"
MY_REPO_URI="https://github.com/jp9000/obs-studio"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${MY_REPO_URI}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="${MY_REPO_URI}/archive/${PV}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa decklink fdk jack imagemagick libcxx luajit pulseaudio python +qt5 ssl speex truetype udev v4l vlc"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
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
	fdk? ( media-libs/fdk-aac:= )
	imagemagick? ( media-gfx/imagemagick:= )
	!imagemagick? ( virtual/ffmpeg )
	jack? ( media-sound/jack-audio-connection-kit )
	libcxx? ( sys-libs/libcxx )
	luajit? ( dev-lang/luajit:2 )
	python? ( ${PYTHON_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	pulseaudio? ( media-sound/pulseaudio )
	python? ( ${PYTHON_DEPS} )
	ssl? ( net-libs/mbedtls )
	truetype? (
		media-libs/fontconfig
		media-libs/freetype
	)
	udev? ( virtual/udev )
	v4l? ( media-libs/libv4l )
	vlc? ( media-video/vlc )"
DEPEND="${COMMON_DEPEND}
	luajit? ( dev-lang/swig )
	python? ( dev-lang/swig )
"
RDEPEND="${COMMON_DEPEND}"

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local libdir
	libdir=$(get_libdir)
	local mycmakeargs=(
		"-DDISABLE_ALSA=$(usex !alsa)"
		"-DDISABLE_DECKLINK=$(usex !decklink)"
		"-DDISABLE_FREETYPE=$(usex !truetype)"
		"-DDISABLE_JACK=$(usex !jack)"
		"-DDISABLE_LIBFDK=$(usex !fdk)"
		"-DDISABLE_PULSEAUDIO=$(usex !pulseaudio)"
		"-DDISABLE_SPEEXDSP=$(usex !speex)"
		"-DDISABLE_UDEV=$(usex !udev)"
		"-DDISABLE_UI=$(usex !qt5)"
		"-DDISABLE_V4L2=$(usex !v4l)"
		"-DDISABLE_VLC=$(usex !vlc)"
		"-DLIBOBS_PREFER_IMAGEMAGICK=$(usex imagemagick)"
		"-DOBS_MULTIARCH_SUFFIX=${libdir#lib}"
		"-DUSE_LIBC++=$(usex libcxx)"
		"-DWITH_RTMPS=$(usex ssl)"
	)

	if use luajit || use python; then
		mycmakeargs+=(
			"-DDISABLE_LUA=$(usex !luajit)"
			"-DDISABLE_PYTHON=$(usex !python)"
			"-DENABLE_SCRIPTING=yes"
		)
	else
		mycmakeargs+=( "-DENABLE_SCRIPTING=no" )
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update

	if ! use alsa && ! use pulseaudio; then
		elog
		elog "For the audio capture features to be available,"
		elog "either the 'alsa' or the 'pulseaudio' USE-flag needs to"
		elog "be enabled."
		elog
	fi

	if ! has_version "sys-apps/dbus"; then
		elog
		elog "The 'sys-apps/dbus' package is not installed, but"
		elog "could be used for disabling hibernating, screensaving,"
		elog "and sleeping.  Where it is not installed,"
		elog "'xdg-screensaver reset' is used instead"
		elog "(if 'x11-misc/xdg-utils' is installed)."
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
