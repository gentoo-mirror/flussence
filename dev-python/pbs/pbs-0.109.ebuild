EAPI="4"

DESCRIPTION="Python subprocess wrapper"
HOMEPAGE="http://pypi.python.org/pypi/pbs"
SRC_URI="http://pypi.python.org/packages/source/p/pbs/${P}.tar.gz"

PYTHON_DEPEND="2:2.7 3:3.2"
inherit distutils

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"
