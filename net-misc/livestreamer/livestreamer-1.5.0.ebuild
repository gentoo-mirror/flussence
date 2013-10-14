EAPI="4"

DESCRIPTION="Play streaming video outside of the browser"
HOMEPAGE="https://github.com/chrippa/livestreamer"
SRC_URI="https://github.com/chrippa/${PN}/archive/v${PV}.tar.gz"

PYTHON_DEPEND="2:2.7 3:3.2"
inherit distutils

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="=dev-python/requests-1.2.3
	dev-python/pbs"
DEPEND="${RDEPEND}
	dev-python/setuptools"
