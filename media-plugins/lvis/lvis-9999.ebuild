# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Programmable audio visualizer"
HOMEPAGE="https://git.sr.ht/~kaniini/lvis"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://git.sr.ht/~kaniini/${PN}"
	inherit meson git-r3
else
	: # no releases yet
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-qt/qtcore-5.9
	>=dev-qt/qtdeclarative-5.9
	>=dev-qt/qtwidgets-5.9
	>=media-sound/audacious-3.10
	media-sound/pulseaudio"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-util/meson-0.50"
