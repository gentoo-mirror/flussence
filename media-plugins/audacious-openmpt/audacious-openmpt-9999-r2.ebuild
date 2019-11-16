# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="libopenmpt-based module (tracker) input plugin for Audacious"
HOMEPAGE="https://github.com/cspiegel/audacious-openmpt"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/cspiegel/${PN}.git"
	inherit git-r3
else
	die "There are no releases for this package yet"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=">=media-libs/libopenmpt-0.3"
RDEPEND="${DEPEND}
	=media-sound/audacious-3*:=
	!media-plugins/audacious-plugins[openmpt(-)]"
