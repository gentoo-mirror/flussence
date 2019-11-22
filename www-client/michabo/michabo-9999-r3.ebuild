# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop meson xdg

DESCRIPTION="A Fediverse client written in Qt"
HOMEPAGE="https://git.pleroma.social/kaniini/michabo"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-r3
else
	MY_P="${PN}-v${PV}"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="${HOMEPAGE}/-/archive/v${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

# is this kosher? probably not.
_qt_deps() {
	for module; do echo ">=dev-qt/qt${module}-5.12:5"; done
}
DEPEND="$(_qt_deps core gui websockets widgets network dbus)"
RDEPEND="${DEPEND}"

src_install() {
	meson_src_install

	domenu michabo.desktop

	# app icons
	local iconsize
	for iconsize in 16 32 64 256; do
		newicon -s "$iconsize" "icons/michabo-${iconsize}.png" "michabo.png"
	done
	newicon -s scalable "icons/michabo-default.svg" "michabo.svg"

	# toolbar icons
	cp -n icons/action-pref{erence,}s.svg # fix your shit kaniini
	for icon in icons/action-*.svg; do
		newicon -s scalable "${icon}" "michabo-${icon##*/}"
	done
}
