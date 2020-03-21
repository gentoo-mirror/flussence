# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
fi

inherit meson

# build system: BSD-2
# embedded libgme: LGPL-2.1
# other internal console players, most plugins: GPL-2+
LICENSE="
	BSD-2
	LGPL-2.1
	GPL-2+
	flac? ( GPL-3+ )
	libnotify? ( GPL-3+ )
	qt5? ( || ( GPL-2 GPL-3 ) )"
SLOT="0"

USE_FRONTENDS="+qt5 +mpris"
USE_CODECS="aac cdda ffmpeg flac fluidsynth lame modplug mp3 openmpt sid vorbis wavpack"
USE_OUTPUTS="alsa encode pulseaudio qtmedia"
USE_TRANSPORTS="http mms streamtuner"
USE_FORMATS="cue +xml"
IUSE="libnotify libsamplerate scrobbler sndfile
	${USE_FRONTENDS} ${USE_CODECS} ${USE_OUTPUTS} ${USE_TRANSPORTS} ${USE_FORMATS}"

REQUIRED_USE="
	|| ( ${USE_FRONTENDS//+/} )
	|| ( ${USE_OUTPUTS//+/} )
	encode? ( || ( flac lame vorbis ) )
	libnotify? ( qt5 )
	qtmedia? ( qt5 )
	scrobbler? ( xml )
	streamtuner? ( qt5 )"

RDEPEND="
	>=dev-libs/glib-2.32
	sys-libs/zlib
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	cdda? (
		>=dev-libs/libcdio-0.70:=
		>=dev-libs/libcdio-paranoia-0.70:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( >=media-libs/libcue-2.0 )
	ffmpeg? ( virtual/ffmpeg )
	flac? ( >=media-libs/flac-1.2.1 )
	fluidsynth? ( >=media-sound/fluidsynth-1.0.6:= )
	http? ( >=net-libs/neon-0.27 )
	mpris? ( >=media-sound/audacious-4.0:=[qt5(-)=,dbus(-)] )
	!mpris? ( >=media-sound/audacious-4.0:=[qt5(-)=] )
	qt5? (
		>=dev-qt/qtcore-5.2:5
		>=dev-qt/qtgui-5.2:5
		>=dev-qt/qtwidgets-5.2:5
		qtmedia? ( dev-qt/qtmultimedia:5 )
		streamtuner? ( dev-qt/qtnetwork:5 )
	)
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate:= )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12 )
	openmpt? ( >=media-libs/libopenmpt-0.2 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.5 )
	scrobbler? ( net-misc/curl )
	sid? ( >=media-libs/libsidplayfp-2.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.19 )
	vorbis? (
		>=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0
	)
	wavpack? ( >=media-sound/wavpack-4.31 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	mpris? ( dev-util/gdbus-codegen )"

PATCHES=(
	# CVE-2017-17446; https://bitbucket.org/mpyne/game-music-emu/issues/14
	"${FILESDIR}"/0001-nsfe-Sanity-check-block-header-size-before-reading.patch
	"${FILESDIR}"/0002-nsfe-Add-some-additional-hardening-and-sanity-checks.patch
)

src_configure() {
	# As of this writing (2019-11-17), these plugins aren't yet meson-ified:
	#   alarm ampache aosd bs2b {cairo-,gl,qtgl}spectrum hotkey jack ladspa lirc oss4 sdlout
	# Some others never will be because they're either not for linux or qt5.
	local emesonargs=(
		"$(meson_use                alsa)"
		"$(meson_use fluidsynth     amidiplug)"
		"$(meson_use cdda           cdaudio)"
		"$(meson_use                cue)"
		"$(meson_use mpris          dbus)"
		"$(meson_use aac            faad)"
		"$(meson_use encode         filewriter)"
		"$(meson_use flac           filewriter-flac)"
		"$(meson_use lame           filewriter-mp3)"
		"$(meson_use vorbis         filewriter-ogg)"
		"$(meson_use                flac)"
		"$(meson_use http           neon)"
		"$(meson_use libnotify      notify)"
		"$(meson_use libsamplerate  resample)"
		"$(meson_use libsamplerate  speedpitch)"
		"$(meson_use                mms)"
		"$(meson_use                modplug)"
		"$(meson_use mp3            mpg123)"
		"$(meson_use mpris          mpris2)"
		"$(meson_use                openmpt)"
		"$(meson_use pulseaudio     pulse)"
		"$(meson_use qt5            qt)"
		"$(meson_use scrobbler      scrobbler2)"
		"$(meson_use sid)"
		"$(meson_use sndfile)"
		"$(meson_use vorbis)"
		"$(meson_use wavpack)"
		"-Dffaudio=$(usex ffmpeg ffmpeg neither)"
	)
	meson_src_configure
}

pkg_postinst() {
	if ! has_version -r app-arch/unzip; then
		einfo "For full winamp2 skin support either install app-arch/unzip,"
		einfo "or set the environment variable UNZIPCMD to a drop-in replacement"
		einfo "(e.g. 'busybox unzip')"
	fi
}
