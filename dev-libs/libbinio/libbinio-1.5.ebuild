# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="adplug"

DESCRIPTION="Platform-independent way to access binary data streams in C++"
LICENSE="LGPL-2.1"
SLOT="0"

inherit github-pkg

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/releases/download/${P}/${P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi
