# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="tavianator"

DESCRIPTION="A breadth-first version of the UNIX find command"
HOMEPAGE="https://tavianator.com/projects/bfs.html"
LICENSE="0BSD"
SLOT="0"
IUSE="acl caps +io-uring oniguruma xattr"

inherit github-pkg

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	acl? ( sys-apps/acl )
	caps? ( sys-libs/libcap )
	io-uring? ( sys-libs/liburing )
	oniguruma? ( dev-libs/oniguruma )
	xattr? ( sys-apps/attr )
"
RDEPEND="${DEPEND}"

src_compile() {
	# the makefile tests these with "ifdef", so simply changing them to "n" won't work.
	emake \
		USE_ACL="$(usex acl y '')" \
		USE_ATTR="$(usex xattr y '')" \
		USE_LIBCAP="$(usex caps y '')" \
		USE_LIBURING="$(usex io-uring y '')" \
		USE_ONIGURUMA="$(usex oniguruma y '')"
}
