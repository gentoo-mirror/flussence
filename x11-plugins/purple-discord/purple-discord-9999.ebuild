# Copyright 2017-2019 Anthony Parsons
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="Pidgin/Purple PRotocol PLugin for Discord"
HOMEPAGE="https://github.com/EionRobb/purple-discord"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin
	dev-libs/json-glib"
RDEPEND="${DEPEND}"
