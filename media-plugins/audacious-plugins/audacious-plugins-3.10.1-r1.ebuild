# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3 autotools
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
fi

LICENSE="BSD-2 LGPL-2 GPL-2+ ampache? ( GPL-3 )"
SLOT="0"

IUSE="aac adplug +alsa ampache aosd bs2b cdda cue ffmpeg filewriter flac fluidsynth gnome hotkeys
	http +gtk jack lame libav libnotify libsamplerate lirc mms modplug mp3 mpris nls opengl oss
	pulseaudio qt5 qtmedia scrobbler sdl sdl2 sid sndfile sox vorbis wavpack
	+bundled-libs"
REQUIRED_USE="
	|| ( alsa jack oss pulseaudio qt5 sdl )
	ampache? ( qt5 http )
	aosd? ( gtk )
	filewriter? ( || ( flac vorbis ) )
	hotkeys? ( gtk )
	opengl? ( || ( gtk qt5 ) )
	qtmedia? ( qt5 )"

RDEPEND="
	dev-libs/libxml2:2
	~media-sound/audacious-${PV}:=[gtk(-)=,qt5(-)=]
	aac? ( >=media-libs/faad2-2.7 )
	adplug? ( media-libs/adplug:= )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( =media-libs/ampache_browser-1* )
	aosd? (
		x11-libs/libXrender
		x11-libs/libXcomposite
	)
	bs2b? ( media-libs/libbs2b )
	cdda? (
		>=dev-libs/libcdio-0.70:=
		>=dev-libs/libcdio-paranoia-0.70:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue )
	ffmpeg? ( virtual/ffmpeg[libav?] )
	flac? (
		>=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	http? ( >=net-libs/neon-0.27 )
	gtk? ( x11-libs/gtk+:2 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		qtmedia? ( dev-qt/qtmultimedia:5 )
	)
	jack? (
		>=media-libs/bio2jack-0.4
		virtual/jack
	)
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate:= )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	opengl? (
		virtual/opengl
		x11-libs/libX11
		qt5? ( dev-qt/qtopengl )
	)
	pulseaudio? ( >=media-sound/pulseaudio-0.9.5 )
	scrobbler? ( net-misc/curl )
	sdl? (
		sdl2? ( >=media-libs/libsdl2-2.0[sound] )
		!sdl2? ( >=media-libs/libsdl-1.2.11[sound] )
	)
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.19 )
	sox? ( media-libs/soxr )
	vorbis? (
		>=media-libs/libvorbis-1.2.0
		>=media-libs/libogg-1.1.3
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )"

DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	mpris? ( dev-util/gdbus-codegen )
	nls? ( sys-devel/gettext )"

PATCHES=(
	# CVE-2017-17446; https://bitbucket.org/mpyne/game-music-emu/issues/14
	"${FILESDIR}"/0001-nsfe-Sanity-check-block-header-size-before-reading.patch
	"${FILESDIR}"/0002-nsfe-Add-some-additional-hardening-and-sanity-checks.patch
)

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	# Upstream bundles several input plugin libs and hardcodes some of those to on.
	# Some of them (libgme) have had pretty serious vulns in the past.
	# You can disable them *partially* with USE=-bundled-libs, but xsf/psf/vtx are force-enabled.
	econf \
		--enable-songchange \
		--disable-coreaudio \
		--disable-sndio \
		"$(use_enable aac)" \
		"$(use_enable adplug)" \
		"$(use_enable alsa)" \
		"$(use_enable ampache)" \
		"$(use_enable aosd)" \
		"$(use_enable bs2b)" \
		"$(use_enable bundled-libs console)" \
		"$(use_enable cdda cdaudio)" \
		"$(use_enable cue)" \
		"$(use_enable filewriter)" \
		"$(use_enable flac)" \
		"$(use_enable fluidsynth amidiplug)" \
		"$(use_enable gtk)" \
		"$(use gtk && use_enable opengl glspectrum)" \
		"$(use_enable hotkeys hotkey)" \
		"$(use_enable http neon)" \
		"$(use_enable jack)" \
		"$(use_enable lame filewriter_mp3)" \
		"$(use_enable libnotify notify)" \
		"$(use_enable libsamplerate resample)" \
		"$(use_enable libsamplerate speedpitch)" \
		"$(use_enable lirc)" \
		"$(use_enable mms)" \
		"$(use_enable modplug)" \
		"$(use_enable mp3 mpg123)" \
		"$(use_enable mpris mpris2)" \
		"$(use_enable nls)" \
		"$(use_enable oss oss4)" \
		"$(use_enable pulseaudio pulse)" \
		"$(use_enable qt5 qt)" \
		"$(use_enable qtmedia qtaudio)" \
		"$(use qt5 && use_enable opengl qtglspectrum)" \
		"$(use_enable scrobbler scrobbler2)" \
		"$(use_enable sdl sdlout)" \
		"$(usex sdl "--with-libsdl=" "" "$(usex sdl2 2 1)")" \
		"$(use_enable sid)" \
		"$(use_enable sndfile)" \
		"$(use_enable sox soxr)" \
		"$(use_enable vorbis)" \
		"$(use_enable wavpack)" \
		"$(use_with ffmpeg ffmpeg "$(usex libav libav ffmpeg)")"
}

pkg_postinst() {
	if ! has_version -r app-arch/unzip; then
		einfo "For full winamp2 skin support either install app-arch/unzip,"
		einfo "or set the environment variable UNZIPCMD to a drop-in replacement"
		einfo "(e.g. 'busybox unzip')"
	fi
}
