# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="yshui"

DESCRIPTION="Picom (née Compton) is an X compositor with XRender and OpenGL/ES 3.0 support."
LICENSE="MPL-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus drm +doc +libconfig +opengl +pcre"

inherit fcaps github-pkg meson xdg

if [[ ${PV} != "9999" ]]; then
	MY_PV="${PV/_rc/-rc}"
	SRC_URI="${GITHUB_HOMEPAGE}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

RDEPEND="
	dev-libs/libev
	>=x11-libs/libxcb-1.9.2
	x11-libs/libXext
	x11-libs/libXdamage
	x11-libs/libXrender
	x11-libs/libXrandr
	x11-libs/libXcomposite
	x11-libs/pixman
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-renderutil
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm )
	libconfig? ( >=dev-libs/libconfig-1.4:= )
	opengl? ( media-libs/libepoxy )
	pcre? ( dev-libs/libpcre2:= )"
DEPEND="${RDEPEND}
	dev-libs/uthash"
BDEPEND="doc? ( app-text/asciidoc )"

FILECAPS=( -m 755 cap_sys_nice+ep "usr/bin/${PN}" )

src_configure() {
	# TODO: support FEATURES=test properly
	local emesonargs=(
		"$(meson_use dbus)"
		"$(meson_use doc with_docs)"
		"$(meson_use drm vsync_drm)"
		"$(meson_use libconfig config_file)"
		"$(meson_use opengl)"
		"$(meson_use pcre regex)"
		"-Dcompton=false"
	)
	meson_src_configure
}

src_install() {
	dodoc CONTRIBUTORS

	docinto examples
	dodoc ./*-fshader-win.glsl ./*.sample.conf
	if use dbus; then
		dodoc -r dbus-examples/
	fi

	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	fcaps_pkg_postinst
}
