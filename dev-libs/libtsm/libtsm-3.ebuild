# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="TSM is a state machine for DEC VT100-VT520 compatible terminal emulators."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/kmscon/libtsm/"
SRC_URI="http://freedesktop.org/software/kmscon/releases/${P}.tar.xz"

LICENSE="MIT LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libxkbcommon"
RDEPEND="${DEPEND}"
