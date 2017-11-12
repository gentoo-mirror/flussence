# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac alsa ampache aosd bs2b cdda cue ffmpeg filewriter flac fluidsynth gnome hotkeys http +gtk
	jack lame libnotify libsamplerate lirc mms modplug mpg123 mpris nls opengl oss pulseaudio qt5
	scrobbler sdl sdl2 sid sndfile sox vorbis wavpack"
REQUIRED_USE="|| ( alsa jack oss pulseaudio qt5 sdl )
	ampache? ( qt5 )
	aosd? ( gtk )
	filewriter? ( || ( flac vorbis ) )
	hotkeys? ( gtk )
	opengl? ( || ( gtk qt5 ) )"

RDEPEND="app-arch/unzip
	dev-libs/libxml2:2
	~media-sound/audacious-${PV}[gtk?,qt5?]
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( www-apps/ampache )
	aosd? (
		x11-libs/libXrender
		x11-libs/libXcomposite
	)
	bs2b? ( >=media-libs/libbs2b-3.0.0 )
	cdda? (
		>=dev-libs/libcdio-paranoia-0.70
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue )
	ffmpeg? ( >=virtual/ffmpeg-0.7.3 )
	flac? ( >=media-libs/flac-1.2.1 )
	fluidsynth? ( media-sound/fluidsynth )
	http? ( >=net-libs/neon-0.27 )
	gnome? ( >=dev-libs/dbus-glib-0.60 )
	gtk? ( x11-libs/gtk+:2 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
	)
	jack? ( >=media-sound/jack-audio-connection-kit-0.120.1 )
	lame? ( media-sound/lame )
	libnotify? (
		>=x11-libs/libnotify-0.7
		>=x11-libs/gdk-pixbuf-2.26:2
	)
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mpris? ( dev-util/gdbus-codegen )
	mpg123? ( >=media-sound/mpg123-1.12.1 )
	opengl? (
		virtual/opengl
		x11-libs/libX11
	)
	pulseaudio? ( >=media-sound/pulseaudio-0.9.5 )
	scrobbler? ( >=net-misc/curl-7.9.7 )
	sdl? (
		sdl2? ( >=media-libs/libsdl2-2.0[sound] )
		!sdl2? ( >=media-libs/libsdl-1.2.11[sound] )
	)
	sid? ( >=media-libs/libsidplayfp-1.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.19 )
	sox? ( media-libs/soxr )
	vorbis? ( >=media-libs/libvorbis-1.2.0
		  >=media-libs/libogg-1.1.3 )
	wavpack? ( >=media-sound/wavpack-4.31 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )
	virtual/pkgconfig"

src_configure() {
	if use ffmpeg; then
		if has_version media-video/ffmpeg; then
			ffmpeg="ffmpeg"
		elif has_version media-video/libav; then
			ffmpeg="libav"
		fi
	fi

	if use sdl; then
		if has_version media-libs/libsdl2; then
			sdl="2"
		else
			sdl="1"
		fi
	fi

	econf \
		--with-ffmpeg="${ffmpeg:-none}" \
		$(use_enable aac) \
		$(use_enable alsa) \
		$(use_enable bs2b) \
		$(use_enable cdda cdaudio) \
		$(use_enable cue) \
		$(use_enable filewriter) \
		$(use_enable flac) \
		$(use_enable fluidsynth amidiplug) \
		$(use_enable gtk) \
		$(use gtk && use_enable opengl glspectrum) \
		$(use_enable hotkeys hotkey) \
		$(use_enable http neon) \
		$(use_enable jack) \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable lame filewriter_mp3) \
		$(use_enable libnotify notify) \
		$(use_enable libsamplerate resample) \
		$(use_enable libsamplerate speedpitch) \
		$(use_enable lirc) \
		$(use_enable mms) \
		$(use_enable modplug) \
		$(use_enable mpg123) \
		$(use_enable nls) \
		$(use_enable oss oss4) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt5 qt) \
		$(use_enable qt5 qtaudio) \
		$(use qt5 && use_enable opengl qtglspectrum) \
		$(use_enable scrobbler scrobbler2) \
		$(use_enable sdl sdlout) \
		$(use_with sdl sdl $(usex sdl2 2 1)) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable sox soxr) \
		$(use_enable vorbis) \
		$(use_enable wavpack)
}
