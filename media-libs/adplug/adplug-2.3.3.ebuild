# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="adplug"

DESCRIPTION="Hardware-independent AdLib sound player library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

inherit github-pkg

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/releases/download/${P}/${P}.tar.bz2"
fi

RDEPEND=">=dev-libs/libbinio-1.4"
DEPEND="${RDEPEND}"
