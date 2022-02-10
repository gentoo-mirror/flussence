# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~x86"

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='xml(+),threads(+)'
DISTUTILS_SINGLE_IMPL=1

inherit github-pkg distutils-r1 optfeature

DESCRIPTION="CLI for extracting streams from websites to a video player of your choice"
HOMEPAGE="https://streamlink.github.io/"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/releases/download/${PV}/${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	$(python_gen_cond_dep "
		dev-python/isodate[\${PYTHON_USEDEP}]
		>=dev-python/lxml-4.6.4[\${PYTHON_USEDEP}]
		dev-python/pycountry[\${PYTHON_USEDEP}]
		>=dev-python/pycryptodome-3.4.3[\${PYTHON_USEDEP}]
		>=dev-python/PySocks-1.5.8[\${PYTHON_USEDEP}]
		>=dev-python/requests-2.26.0[\${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.2.1[\${PYTHON_USEDEP}]
	")
"
BDEPEND="
	$(python_gen_cond_dep "
		test? (
			dev-python/mock[\${PYTHON_USEDEP}]
			dev-python/requests-mock[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			>=dev-python/freezegun-1.0.0[\${PYTHON_USEDEP}]
		)
	")"

python_test() {
	esetup.py test
}

pkg_postinst() {
	optfeature "Muxing downloaded stream parts into a single file" media-video/ffmpeg
}
