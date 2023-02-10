# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="tavianator"
KEYWORDS="~amd64 ~x86"

inherit github-pkg

DESCRIPTION="A breadth-first version of the UNIX find command"
HOMEPAGE="https://tavianator.com/projects/bfs.html"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="0BSD"
SLOT="0"
IUSE="acl caps oniguruma xattr"

DEPEND="
	acl? ( sys-apps/acl )
	caps? ( sys-libs/libcap )
	oniguruma? ( dev-libs/oniguruma )
	xattr? ( sys-apps/attr )
"
RDEPEND="${DEPEND}"

src_compile() {
	# the makefile tests these with "ifdef", so simply changing them to "n" won't work.
	emake \
		WITH_ACL="$(usex acl y '')" \
		WITH_ATTR="$(usex xattr y '')" \
		WITH_LIBCAP="$(usex caps y '')" \
		WITH_ONIGURUMA="$(usex oniguruma y '')"
}
