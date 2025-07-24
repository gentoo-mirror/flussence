# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Wayland compositor that runs full X11 WMs"
HOMEPAGE="https://gitlab.freedesktop.org/wayback/wayback"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayback/wayback.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man"

DEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/libxkbcommon
	>=gui-libs/wlroots-0.18
	man? ( app-text/scdoc )
"
RDEPEND="${DEPEND}
	>=x11-base/xwayland-24.1"

src_configure() {
	local emesonargs=(
		"$(meson_feature man generate_manpages)"
	)
	meson_src_configure
}
