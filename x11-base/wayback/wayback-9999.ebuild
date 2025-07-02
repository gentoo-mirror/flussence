# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="kaniini"

DESCRIPTION="Wayland compositor that runs full X11 WMs"
LICENSE="MIT"
SLOT="0"

inherit github-pkg meson

if [[ ${PV} != 9999 ]]; then
	eerror "no releases yet"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/libxkbcommon
	>=gui-libs/wlroots-0.19
"
RDEPEND="${DEPEND}
	x11-base/xwayland"
