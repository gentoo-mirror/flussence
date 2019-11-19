# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="himdel"
KEYWORDS="~amd64 ~x86"

inherit github-pkg

DESCRIPTION="Tool which allows you to compose wallpapers ('root pixmaps') for X"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXinerama"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md )

src_prepare() {
	# underlinking with --as-needed due to misplaced -l flags in implicit make rules
	sed -i \
		-e 's/^LDFLAGS/LDLIBS/' \
		-e '/--no-as-needed/d' \
		Makefile || die

	default
}

src_install() {
	# makefile install rule calls strip, so do it manually
	dobin hsetroot hsr-outputs
}
