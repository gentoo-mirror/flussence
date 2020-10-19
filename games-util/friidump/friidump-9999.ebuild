# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="bradenmcd"
KEYWORDS="~amd64"

inherit cmake fcaps github-pkg

DESCRIPTION="Dump Nintendo Wii and GameCube discs"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${PV}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

FILECAPS=(
	'-g' cdrom '-m' 4710 '-M' 0710 cap_sys_rawio /usr/bin/friidump
)

src_configure() {
	# can't be bothered dealing with multilib nonsense
	local mycmakeargs+=(
		'-DBUILD_STATIC_BINARY=1'
	)
	cmake_src_configure
}
