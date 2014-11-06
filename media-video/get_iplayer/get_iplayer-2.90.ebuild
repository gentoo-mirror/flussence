# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Lists, Records and Streams BBC iPlayer TV and Radio programmes."
HOMEPAGE="http://www.infradead.org/get_iplayer/html/get_iplayer.html"
SRC_URI="ftp://ftp.infradead.org/pub/get_iplayer/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg id3tag mplayer +perl"

DEPEND=">=dev-lang/perl-5.8.8
dev-perl/libwww-perl
media-video/rtmpdump
ffmpeg? ( media-video/ffmpeg )
id3tag? ( perl? ( dev-perl/MP3-Tag ) !perl? ( media-sound/id3v2 ) )
mplayer? ( media-video/mplayer )"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	insinto /usr/share/${PN}/plugins
	doins plugins/*
}
