# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="losnoco"
KEYWORDS="~amd64 ~x86"

inherit cmake-utils github-pkg

DESCRIPTION="A library for playback of various streamed audio formats used in video games"

# Magic Non-Semantic-Version Decoder Wheel!!1
# Most upstream releases are of the form rx{r(\d+)-(\d+)[-g<.git-shorthash>]?}
# For added fun there's a few normal-looking ones mixed in. We just don't bother with them.
# (getting real Net::FullAuto vibes from this thing…)
if [[ ${PV} != 9999 ]]; then
	MY_PV="${PV%%_p*}"
	case "${PV##*_p}" in
		20200211) MY_PV+="-g5ea57c08" ;;
		*) : ;;
	esac
	SRC_URI="${GITHUB_HOMEPAGE}/archive/r${MY_PV//./-}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="ISC"
SLOT="0"

# USE=fdk is use.masked; fails to build because it tries to read libmp4v2's config.h.in (wtf).
# Several codecs are gated behind "if(WIN32)".
# The audacious plugin uses gtk3 for half a dozen checkboxes.
# It doesn't provide significant functionality over libgme.
# I'm not sure why I went to the effort of trying to package this.
# This ebuild exists more as a cautionary tale than anything you should actually use.
IUSE="+audacious cli fdk ffmpeg mp3 vorbis"

DEPEND="
	audacious? (
		>=media-sound/audacious-3.6
		x11-libs/gtk+:3
	)
	cli? ( media-libs/libao )
	fdk? ( media-libs/libmp4v2 )
	ffmpeg? ( virtual/ffmpeg )
	mp3? ( media-sound/mpg123 )
	vorbis? ( media-libs/libvorbis )
	"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		"-DBUILD_AUDACIOUS=$(usex audacious)"
		"-DBUILD_CLI=$(usex cli)"
		"-DUSE_FDKAAC=$(usex fdk)"
		"-DUSE_FFMPEG=$(usex fdk)"
		"-DUSE_MPEG=$(usex mp3)"
		"-DUSE_VORBIS=$(usex vorbis)"
		"-DFDK_AAC_PATH=${EPREFIX}/usr/include"
		"-DQAAC_PATH=${EPREFIX}/usr/include"
	)

	cmake-utils_src_configure
}
