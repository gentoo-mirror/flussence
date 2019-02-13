# Copyright 2019 Anthony Parsons
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils fcaps

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

FILECAPS=(
	'-g' cdrom '-m' 4710 '-M' 0710 cap_sys_rawio /usr/bin/friidump
)

src_configure() {
	# can't be bothered dealing with multilib nonsense
	local mycmakeargs+=(
		'-DBUILD_STATIC_BINARY=1'
	)
	cmake-utils_src_configure
}
