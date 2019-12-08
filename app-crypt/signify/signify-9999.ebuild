# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="aperezdc"
KEYWORDS="~amd64 ~x86"

inherit github-pkg toolchain-funcs

DESCRIPTION="Cryptographically sign and verify files"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/releases/download/v${PV}/${P}.tar.xz"
fi

LICENSE="ISC"
SLOT="0"
# TODO: add libwaive support via USE=seccomp. Will require a ???-libs/libwaive-9999 package
# and patching the Makefile to unbundle the submodule and use LDLIBS+= instead of LDFLAGS+=

DEPEND=">=dev-libs/libbsd-0.8"
RDEPEND="${DEPEND}"

DOCS=( README.md CHANGELOG.md )

src_configure() {
	tc-export CC
}

src_install() {
	export PREFIX=/usr
	default
}
