# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast PlayStation 1 emulator"
HOMEPAGE="https://www.duckstation.org/"
KEYWORDS="~amd64"

if [[ ${PV} == "0.1_p4933" ]]; then
	# last working Qt5 revision
	EGIT_COMMIT="f6b3652ae6c2542dbac948e55d799ec273d5c9bd"
	EGIT_REPO_URI="https://github.com/stenzek/duckstation.git"
	inherit git-r3
else
	SRC_URI="https://github.com/stenzek/duckstation/archive/${PV}.tar.gz -> ${P}.tar.gz"
	# don't know what to do about these yet
	die "TODO"
fi

LICENSE="GPL-3"
SLOT="0"

# These reflect upstream's default settings
IUSE="+evdev fbdev kms +qt5 +sdl2 wayland +X"

DEPEND="
	app-arch/xz-utils
	dev-libs/libchdr
	dev-libs/rapidjson
	dev-libs/stb
	dev-libs/tinyxml2
	dev-libs/xxhash
	media-libs/cubeb
	media-libs/flac
	media-libs/libsamplerate
	sys-libs/zlib
	evdev? ( dev-libs/libevdev )
	sdl2? ( media-libs/libsdl2 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/patchelf"

# Duckstation is Windows software that only incidentally works on Linux (and loathes it at that),
# and has no concept of playing nice with the OS or FHS. We'll give it our best shot below.

src_prepare() {
	# Patch things to look in /usr/share/duckstation instead of dirname(readlink(/proc/self/exe))
	sed -i -e "s@FileSystem::GetPathDirectory(FileSystem::GetProgramPath())@\"/usr/share/${PN}\"@" \
		"${S}"/src/core/host_interface.cpp
	sed -i -e "s@qApp->applicationDirPath()@\"/usr/share/${PN}\"@" \
		"${S}"/src/duckstation-qt/qthostinterface.cpp

	cmake_src_prepare
}

src_configure() {
	# There are no corresponding gentoo packages for:
	#  glad imgui simpleini googletest discord-rpc rcheevos vixl
	# Fixing these is non-trivial (hardcoded header paths and cmake superfund site):
	#  zlib rapidjson minizip vulkan-loader glslang xxhash libchdr lzma libFLAC
	for bundled in libsamplerate tinyxml2 cubeb; do
		cmake_run_in "dep" cmake_comment_add_subdirectory "${bundled}"
	done

	local mycmakeargs=(
		"-DUSE_EVDEV=$(usex evdev)"
		"-DUSE_FBDEV=$(usex fbdev)"
		"-DUSE_DRMKMS=$(usex kms)"
		"-DUSE_SDL2=$(usex sdl2)"
		"-DUSE_WAYLAND=$(usex wayland)"
		"-DUSE_X11=$(usex X)"
	)

	cmake_src_configure
}

# Every idea I've had for this part feels dirty, this is the least.
src_install() {
	local libdir
	libdir="/usr/$(get_libdir)/${PN}"

	cd "${BUILD_DIR}/bin" || die

	# Remove test stuff, which gets built unconditionally
	rm -f common-tests libgtest{,_main}.so

	# These things look for bundled libs, teach them the correct path to those
	patchelf --set-rpath "${libdir}" \
		./duckstation-* \
		./lib{frontend-common,common,core,libchdr,minizip,stb,util}.so

	dobin ./duckstation-*

	insinto "${libdir}"
	doins ./lib*.so

	insinto "/usr/share/${PN}"
	doins -r ./{database,inputprofiles,resources,shaders,translations}/
}
