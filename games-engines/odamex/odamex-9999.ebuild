# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6 # restricted by wxwidgets.eclass

GITHUB_USER="odamex"
# N.B. upstream explicitly supports a whole bunch of arches,
# but we're hamstrung by sdl2-mixer::gentoo's lack of keywords
KEYWORDS="~amd64 ~arm ~x86"

inherit cmake-utils desktop github-pkg xdg-utils wxwidgets

DESCRIPTION="Online Multiplayer Doom port with a strong focus on the original gameplay"
HOMEPAGE="https://odamex.net"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="asan +client debug dedicated +launcher master portmidi +sdl2 static upnp"

REQUIRED_USE="
	|| ( client dedicated master )
	asan? ( debug )
	upnp? ( dedicated )
"

DEPEND="
	client? (
		media-libs/libpng:0=
		sys-libs/zlib
		sdl2? (
			media-libs/libsdl2[X,joystick,sound,video]
			media-libs/sdl2-mixer[midi,mod]
		)
		!sdl2? (
			media-libs/libsdl[X,joystick,sound,video]
			media-libs/sdl-mixer[midi,mod]
		)
		portmidi? ( media-libs/portmidi )
	)
	dedicated? (
		dev-libs/jsoncpp
		upnp? ( net-libs/miniupnpc )
	)
	launcher? (
		x11-libs/wxGTK:=[X]
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	asan? ( || (
		>=sys-devel/gcc-4.8.0[sanitize]
		>=sys-devel/clang-runtime-3.1.0[sanitize]
	) )
"

PATCHES=(
	"${FILESDIR}"/unbundle-jsoncpp-"${PV}".patch
	"${FILESDIR}"/unbundle-miniupnpc-"${PV}".patch
)

src_prepare() {
	cmake-utils_src_prepare
	rm -r README.md libraries/{jsoncpp,libminiupnpc,libpng,portmidi,zlib}
}

src_configure() {
	local mycmakeargs=(
		"-DBUILD_CLIENT=$(usex client)"
		"-DBUILD_MASTER=$(usex master)"
		"-DBUILD_ODALAUNCH=$(usex launcher)"
		"-DBUILD_SERVER=$(usex dedicated)"
		"-DENABLE_PORTMIDI=$(usex portmidi)"
		"-DUSE_MINIUPNP=$(usex upnp)"
		"-DUSE_SANITIZE_ADDRESS=$(usex asan)"
		"-DUSE_SDL12=$(usex !sdl2)"
		"-DUSE_STATIC_STDLIB=$(usex static)"
	)

	use debug && CMAKE_BUILD_TYPE=Debug

	cmake-utils_src_configure
}

_odamex_do_launcher() {
	local iconsize binary=${1} name=${2}
	for iconsize in 96 128 256 512; do
		newicon -s $iconsize "${S}/media/icon_${binary}_${iconsize}.png" "${binary}.png"
	done
	make_desktop_entry "$binary" "$name" "$binary" "Game;ActionGame"
}

src_install() {
	cmake-utils_src_install

	local iconname
	if use client; then
		_odamex_do_launcher "${PN}" "Odamex"
	fi

	if use launcher; then
		_odamex_do_launcher "odalaunch" "Odamex Launcher"
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
