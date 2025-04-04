# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"
S="${WORKDIR}/${MY_P}"
# build system: BSD-2
# embedded libgme, adplug: LGPL-2.1
# other internal console players, most plugins: GPL-2+
# GUI is GPL-3 only: src/skins/main.h is explicit about it.
LICENSE="
	BSD-2
	LGPL-2.1
	GPL-2+
	ampache? ( GPL-3 )
	flac? ( GPL-3+ )
	gtk2? ( GPL-3 )
	gtk3? ( !gtk2? ( GPL-3 ) )
	libnotify? ( GPL-3+ )
	qt5? ( GPL-3 )
	qt6? ( GPL-3 )"
SLOT="0"

if [[ ${PV} == "9999" ]]; then
	# This ebuild revision is for d43986cfec or later
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
	inherit verify-sig
	SRC_URI+=" verify-sig? ( ${SRC_URI%%.tar*}.sha256sum )"
fi

inherit meson

# These are arranged in the order meson_options.txt presents them
declare -A USE_CATEGORIES=(
	[gui]="gtk2 gtk3 +qt5 qt6"
	[container]="cue"
	[transport]="mms http"

	[input]="aac adplug cdda cddb ffmpeg fluidsynth +gme modplug mp3 openmpt opus sid sndfile wavpack"
	# At least one output must be enabled:
	[output]="+alsa coreaudio encode jack oss pipewire pulseaudio qtmedia sdl sndio"
	# flac and vorbis are also input plugins:
	[filewriter]="flac lame vorbis"

	# plugins without specific handling. USE=xml enables several playlist formats
	[general]="scrobbler +songchange xml"

	# GUI is optional but you need at least one frontend type. The secret third option is audtool
	# (in the main package), but both that and mpris need DBus
	[frontend]="mpris2 +gui"

	[effect]="bs2b libsamplerate soxr"

	# gui_* are plugins that require a GUI, handled specially below
	[gui_base]="+hotkeys +vumeter libnotify opengl"
	[gui_gtk]="aosd lirc"
	[gui_qt]="ampache qtmedia streamtuner"
)

IUSE="${USE_CATEGORIES[*]}"
# shellcheck disable=SC2086 #(word splitting in the printfs is intentional)
REQUIRED_USE="
	|| ( ${USE_CATEGORIES[output]//[+-]/} )
	|| ( ${USE_CATEGORIES[frontend]//[+-]/} )
	encode?    ( || ( ${USE_CATEGORIES[filewriter]//[+-]/} ) )
	gui?       ( || ( ${USE_CATEGORIES[gui]//[+-]/} ) )
	cddb?      ( cdda )
	scrobbler? ( xml )
	$(printf '\n\t%s?\t( gui )'              ${USE_CATEGORIES[gui_base]//[+-]/})
	$(printf '\n\t%s?\t( || ( gtk2 gtk3 ) )' ${USE_CATEGORIES[gui_gtk]//[+-]/})
	$(printf '\n\t%s?\t( || ( qt5 qt6 ) )'   ${USE_CATEGORIES[gui_qt]//[+-]/})
"

# hotkeys currently has automagic detection
RDEPEND="
	>=dev-libs/glib-2.32
	~media-sound/audacious-${PV}:=[gtk2(-)?,gtk3(-)?,qt5(-)?,qt6(-)?]
	sys-libs/zlib:=
	aac? ( >=media-libs/faad2-2.7 )
	adplug? ( media-libs/adplug )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( media-libs/ampache_browser )
	aosd? (
		x11-libs/libXrender
		x11-libs/libXcomposite
	)
	bs2b? ( >=media-libs/libbs2b-3.0.0 )
	cdda? (
		>=dev-libs/libcdio-0.70:=
		>=dev-libs/libcdio-paranoia-0.70:=
		cddb? ( >=media-libs/libcddb-1.2.1 )
	)
	cue? ( >=media-libs/libcue-2.0 )
	ffmpeg? ( >=media-video/ffmpeg-4.2.4:= )
	flac? ( >=media-libs/flac-1.2.1:=[ogg] )
	fluidsynth? ( >=media-sound/fluidsynth-1.0.6:= )
	gtk2? ( >=x11-libs/gtk+-2.24:2 )
	gtk3? ( >=x11-libs/gtk+-3.22:3 )
	http? ( >=net-libs/neon-0.27:= )
	jack? ( virtual/jack )
	lirc? ( app-misc/lirc )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		hotkeys? ( dev-qt/qtx11extras:5 )
		opengl? ( dev-qt/qtopengl:5 )
		qtmedia? ( dev-qt/qtmultimedia:5 )
		streamtuner? ( dev-qt/qtnetwork:5 )
	)
	qt6? (
		!qt5? (
			dev-qt/qtbase:6[gui,widgets]
			opengl? ( dev-qt/qtbase:6[opengl] )
			qtmedia? ( dev-qt/qtmultimedia:6 )
			streamtuner? ( dev-qt/qtbase:6[network] )
		)
	)
	lame? ( media-sound/lame )
	libnotify? (
		>=x11-libs/libnotify-0.7
		>=x11-libs/gdk-pixbuf-2.26
	)
	libsamplerate? ( media-libs/libsamplerate:= )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12 )
	opengl? ( virtual/opengl )
	openmpt? ( >=media-libs/libopenmpt-0.2 )
	opus? (
		>=media-libs/opus-1.0.1
		>=media-libs/opusfile-0.4
	)
	pipewire? ( >=media-video/pipewire-0.3.33 )
	pulseaudio? ( media-libs/libpulse )
	scrobbler? ( net-misc/curl )
	sdl? ( >=media-libs/libsdl3-3.2.0 )
	sid? ( >=media-libs/libsidplayfp-2.0:= )
	sndfile? ( >=media-libs/libsndfile-1.0.19 )
	sndio? ( media-sound/sndio:= )
	soxr? ( media-libs/soxr )
	vorbis? (
		>=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0
	)
	wavpack? ( >=media-sound/wavpack-4.31 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	mpris2? ( dev-util/gdbus-codegen )"

PATCHES=(
	# CVE-2017-17446; https://bitbucket.org/mpyne/game-music-emu/issues/14
	"${FILESDIR}"/0001-nsfe-Sanity-check-block-header-size-before-reading.patch
	"${FILESDIR}"/0002-nsfe-Add-some-additional-hardening-and-sanity-checks.patch
)

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	elif use verify-sig; then
		pushd "${DISTDIR}" || die
		verify-sig_verify_unsigned_checksums "${A##* }" sha256 "${A%% *}"
		popd || die
	fi

	default
}

src_configure() {
	# USE-to-meson map, mostly grouped in the same way as the array above
	local emesonargs=(
		# GUI toolkits
		"$(meson_use "$(usex gtk2 gtk2 gtk3)" gtk)"
		"$(meson_use "$(usex qt5 qt5 qt6)" qt)"
		"$(meson_use gtk2)"
		"$(meson_use qt5)"

		# container plugins
		"$(meson_use            cue)"

		# transport plugins
		"$(meson_use            mms)"
		"$(meson_use http       neon)"

		# input plugins
		"$(meson_use            aac)"
		"$(meson_use            adplug)"
		"$(meson_use fluidsynth amidiplug)"
		"$(meson_use cdda       cdaudio)"
		"$(meson_use cddb       cdaudio-cddb)"
		"$(meson_use gme        console)"
		"$(meson_use ffmpeg     ffaudio)"
		"$(meson_use            flac)"
		"$(meson_use            modplug)"
		"$(meson_use mp3        mpg123)"
		"$(meson_use            openmpt)"
		"$(meson_use            opus)"
		"$(meson_use            sid)"
		"$(meson_use            sndfile)"
		"$(meson_use            vorbis)"
		"$(meson_use            wavpack)"

		# output plugins
		"$(meson_use            alsa)"
		"$(meson_use            coreaudio)"
		"$(meson_use encode     filewriter)"
		"$(meson_use flac       filewriter-flac)"
		"$(meson_use lame       filewriter-mp3)"
		"$(meson_use vorbis     filewriter-ogg)"
		"$(meson_use            jack)"
		"$(meson_use            oss)"
		"$(meson_use pulseaudio pulse)"
		"$(meson_use qtmedia    qtaudio)"
		"$(meson_use sdl        sdlout)"
		"$(meson_use            sndio)"

		# general plugins
		"$(meson_use            ampache)"
		"$(meson_use            aosd)"
		"$(meson_use hotkeys    hotkey)"
		"$(meson_use            lirc)"
		"$(meson_use            mpris2)"
		"$(meson_use libnotify  notify)"
		"$(meson_use scrobbler  scrobbler2)"
		"$(meson_use            songchange)"
		"$(meson_use            streamtuner)"

		# effect plugins
		"$(meson_use            bs2b)"
		"$(meson_use libsamplerate resample)"
		"$(meson_use            soxr)"
		"$(meson_use libsamplerate speedpitch)"

		# visualisation plugins
		"$(meson_use opengl     gl-spectrum)"
		"$(meson_use            vumeter)"
	)
	meson_src_configure
}

pkg_postinst() {
	if ! has_version -r app-arch/unzip; then
		einfo "For full winamp2 .wsz skin support either install app-arch/unzip,"
		einfo "or set the environment variable UNZIPCMD to a drop-in replacement"
		einfo "(e.g. 'busybox unzip')"
	fi
	if use qt6 && ! use qt5; then
		einfo "The Winamp skin frontend does not play nice with Qt6's high-DPI support,"
		einfo "especially with fractional scaling. See https://doc.qt.io/qt-6/highdpi.html for"
		einfo "a list of environment variables you can tweak to work around this."
		einfo "Suggested: QT_SCALE_FACTOR_ROUNDING_POLICY=Round QT_USE_PHYSICAL_DPI=1"
	fi
}
