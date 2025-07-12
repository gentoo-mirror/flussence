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
	eerror "no releases yet"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/libxkbcommon
	>=gui-libs/wlroots-0.19
"
RDEPEND="${DEPEND}
	x11-base/xwayland"
