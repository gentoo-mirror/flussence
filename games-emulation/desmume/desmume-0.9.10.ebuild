# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/desmume/desmume-0.9.9.ebuild,v 1.1 2013/05/28 10:34:08 hanno Exp $

EAPI="5"

inherit games

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="http://desmume.org/"
SRC_URI="mirror://sourceforge/desmume/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="agg openal osmesa wifi"

DEPEND=">=x11-libs/gtk+-2.8.0:2
	gnome-base/libglade
	x11-libs/gtkglext
	virtual/opengl
	sys-libs/zlib
	dev-libs/zziplib
	media-libs/libsdl[joystick]
	media-libs/libsoundtouch
	agg? ( x11-libs/agg )
	osmesa? ( media-libs/mesa[osmesa] )"
RDEPEND="${DEPEND}"

src_configure() {
	egamesconf \
			--datadir=/usr/share \
			--disable-dependency-tracking \
			$(use_enable agg hud) \
			$(use_enable openal) \
			$(use_enable osmesa) \
			$(use_enable wifi) \
		|| die "egamesconf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS ChangeLog README README.LIN
	prepgamesdirs
}
