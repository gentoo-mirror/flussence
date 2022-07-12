# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="trezor"
PYTHON_COMPAT=( python3_{9..11} )
KEYWORDS="~amd64 ~x86"

inherit github-pkg distutils-r1

DESCRIPTION="Python bindings to the hidapi library"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
else
	EGIT_SUBMODULES=()
fi

LICENSE="|| ( GPL-3 BSD )"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
#	>=dev-libs/hidapi-${PV}"
DEPEND="${RDEPEND}"

# requires hidapi-$PV, which ::gentoo does not have and I can't be bothered to package
#python_configure_all() {
#	mydistutilsargs=( --with-system-hidapi )
#}
