# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="trezor"
PYTHON_COMPAT=( python3_{7,8,9} )
KEYWORDS="~amd64 ~x86"

inherit github-pkg distutils-r1

DESCRIPTION="Python bindings to the hidapi library"

case "${PV}" in
	9999* )
		EGIT_SUBMODULES=() ;;
	0.10.0_p1 )
		MY_PV="f8b11b43c3ddd2f31d164b999074aa60c3746a3e" ;;
	0.10.1 )
		MY_PV="6539756c42cddf63cfee3eb40f5e570c0cb9d1ec" ;;
	* )
		MY_PV="${PV/_p/.post}"
esac

if [[ -n ${MY_PV} ]]; then
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="|| ( GPL-3 BSD )"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/hidapi"
DEPEND="${RDEPEND}"

python_configure_all() {
	mydistutilsargs=( --with-system-hidapi )
}
