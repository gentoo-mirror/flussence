# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="An online multiplayer, free software engine for Doom and Doom II"
HOMEPAGE="http://odamex.net/"
SRC_URI="mirror://sourceforge/${PN}/Odamex/${PV}/${PN}-src-${PV}.tar.bz2"
S="${WORKDIR}/${PN}-src-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

# Unfortunately odamex's makefile doesn't let us build server/client/launcher
# separately, so you have to take all of them for now.
# Also it ignores your CFLAGS setting.
DEPEND="x11-libs/wxGTK:2.8[X]
	>=media-libs/libsdl-1.2.9
	>=media-libs/sdl-mixer-1.2.6
	test? ( dev-lang/tcl )"
RDEPEND="${DEPEND}"

src_compile() {
	emake odamex odasrv odalaunch/odalaunch || die
}

src_install() {
	emake INSTALLDIR="${D}/${GAMES_BINDIR}" \
		RESDIR="${D}/${GAMES_DATADIR}" install || die

	newicon "${S}/media/icon_odamex_128.png" "odamex.png"
	newicon "${S}/media/icon_odalaunch_128.png" "odalaunch.png"

	# FIXME: the icon doesn't show in the menu for some reason
	make_desktop_entry odamex "Odamex" odamex
	make_desktop_entry odalaunch "Odamex Launcher" odalaunch
}
