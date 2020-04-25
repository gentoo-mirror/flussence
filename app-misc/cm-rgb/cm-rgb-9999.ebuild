# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="gfduszynski"
KEYWORDS="~amd64 ~x86"

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_SINGLE_IMPL="🐌̴̵̶̷̸̡̢̧̨̛̖̗̘̙̜̝̞̟̠̣̤̥̦̩̪̫̬̭̮̯̰̱̲̳̹̺̻̼͇͈͉͍͎̀́̂̃̄̅̆̇̈̉̊̋̌̍̎̏̐̑̒̓̔̽̾̿̀́͂̓̈́͆͊͋͌̕̚ͅ͏͓͔͕͖͙͚͐͑͒͗͛ͣͤͥͦͧͨͩͪͫͬͭͮͯ͘͜͟͢͝͞͠͡"
IUSE="+python_single_target_python3_7" # silence pkgcheck

inherit github-pkg distutils-r1 udev

DESCRIPTION="Python library and CLI tools to control the RGB LEDs on the AMD Wraith heatsink"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(for dep_PN in "click" "cython-hidapi" "psutil"; do
		python_gen_cond_dep "dev-python/${dep_PN}[\${PYTHON_MULTI_USEDEP}]"
	done)"
DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install
	udev_dorules "${FILESDIR}"/60-cm-rgb.rules
}

pkg_postinst() {
	udev_reload
}
