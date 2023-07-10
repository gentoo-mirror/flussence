# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cross-platform C++ and C library to decode tracked music files (modules)"
HOMEPAGE="https://lib.openmpt.org/libopenmpt/"
SRC_URI="https://lib.openmpt.org/files/${PN}/src/${P}+release.autotools.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# mp3, vorbis and zlib are enabled by default, because if you're installing this you probably want
# better compatiblity than libmodplug.
IUSE="cli examples flac +mp3 portaudio pulseaudio sdl sdl2 sndfile +vorbis +zlib"

REQUIRED_USE="
	flac? ( cli )
	portaudio? ( cli )
	pulseaudio? ( cli )
	sdl? ( cli )
	sdl2? ( cli !sdl )
	sndfile? ( cli )
"

DEPEND="
	cli? (
		flac? ( >=media-libs/flac-1.3.0 )
		portaudio? ( media-libs/portaudio[cxx] )
		pulseaudio? ( media-libs/libpulse )
		sdl? ( media-libs/libsdl )
		sdl2? ( media-libs/libsdl2 )
		sndfile? ( media-libs/libsndfile )
	)
	mp3? ( >=media-sound/mpg123-1.14.0 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}+release.autotools"

src_configure() {
	econf \
		"$(use_enable cli openmpt123)" \
			"$(use_with flac)" \
			"$(use_with portaudio)" \
			"$(use_with portaudio portaudiocpp)" \
			"$(use_with pulseaudio)" \
			"$(use !sdl2 && use_with sdl)" \
			"$(use_with sdl2)" \
			"$(use_with sndfile)" \
		"$(use_enable examples)" \
		"$(use_with mp3 mpg123)" \
		"$(use_with vorbis ogg)" \
		"$(use_with vorbis)" \
		"$(use_with vorbis vorbisfile)" \
		"$(use_with zlib)"
}
