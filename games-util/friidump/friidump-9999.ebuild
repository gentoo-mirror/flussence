# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Dump Nintendo Wii and GameCube discs"
HOMEPAGE="https://github.com/bradenmcd/friidump"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	# can't be bothered dealing with multilib nonsense
	local mycmakeargs+=(
		-DBUILD_STATIC_BINARY=1
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	fowners root:cdrom /usr/bin/friidump
	fperms 4750 /usr/bin/friidump
}
