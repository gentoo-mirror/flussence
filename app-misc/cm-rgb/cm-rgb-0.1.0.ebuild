# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="gfduszynski"
PYTHON_COMPAT=( python3_{6,7,8} )
KEYWORDS="~amd64 ~x86"

inherit github-pkg distutils-r1

DESCRIPTION="Python library and CLI tools to control the RGB LEDs on the AMD Wraith heatsink"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cython-hidapi[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
