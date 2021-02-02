# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="adplug"
KEYWORDS="~amd64 ~x86"

inherit github-pkg

DESCRIPTION="Hardware-independent AdLib sound player library"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/releases/download/${P}/${P}.tar.bz2"
fi

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND=">=dev-libs/libbinio-1.4"
DEPEND="${RDEPEND}"
