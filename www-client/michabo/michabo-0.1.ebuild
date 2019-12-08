# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="A Fediverse client written in Qt"
HOMEPAGE="https://git.pleroma.social/kaniini/michabo"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-r3
else
	MY_P="${PN}-v${PV}"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://git.pleroma.social/kaniini/michabo/-/archive/v${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

src_compile() {
	eqmake5
	emake
}

src_install() {
	dodoc README*
	dobin Michabo

	domenu michabo.desktop
	local iconsize
	for iconsize in 16 32 64 256; do
		newicon -s "$iconsize" "icons/michabo-${iconsize}.png" "Michabo.png"
	done
}
