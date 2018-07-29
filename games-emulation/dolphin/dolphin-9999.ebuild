# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar ca cs da de el en es fa fr hr hu it ja ko ms nb nl pl pt pt_BR ro ru sr sv tr zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit cmake-utils desktop gnome2-utils l10n pax-utils toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.zip -> ${P}.zip"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://www.dolphin-emu.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa bluez +discord doc egl +evdev ffmpeg libav llvm log lto profile pulseaudio +qt5 sdl upnp web-report"

RDEPEND="
	dev-libs/hidapi
	dev-libs/lzo
	dev-libs/pugixml
	dev-libs/xxhash
	dev-util/glslang
	media-libs/libpng:0=
	media-libs/libsfml
	media-libs/vulkan-loader
	net-libs/enet:1.3
	net-libs/mbedtls
	sys-libs/readline:0=
	sys-libs/zlib
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb:1
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	bluez? ( net-wireless/bluez )
	egl? ( media-libs/mesa[egl] )
	evdev? (
		dev-libs/libevdev
		virtual/udev
	)
	ffmpeg? ( virtual/ffmpeg[libav=] )
	llvm? ( sys-devel/llvm:= )
	profile? ( dev-util/oprofile )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[haptic,joystick] )
	upnp? ( net-libs/miniupnpc )"
DEPEND="${RDEPEND}
	app-arch/zip
	media-libs/freetype
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	cmake-utils_src_prepare

	## Let portage manage ccache. Thanks Anthony Parsons
	sed -i -e '/CCache/s/^/#/' CMakeLists.txt || die

	## Unbundle vulkan
	sed -i -e '/vulkan\/vulkan.h/ {s/"/</; s/"/>/}' Source/Core/VideoBackends/Vulkan/VulkanLoader.h || die
	sed -i -e '/vk_platform.h/ {s:":<vulkan/:; s/"/>/}' Externals/Vulkan/Include/vulkan/vulkan.h || die

	## Unbundle xxhash
	sed -i -e '/if(NOT XXHASH_FOUND)/,+4d' CMakeLists.txt || die
	## Unbundle glslang
	sed -i -e 's:"GlslangToSpv.h":<SPIRV/GlslangToSpv.h>:' \
		   -e 's:"ShaderLang.h":<glslang/Public/ShaderLang.h>:' \
		   -e 's:"disassemble.h":<SPIRV/disassemble.h>:' \
		Source/Core/VideoBackends/Vulkan/ShaderCompiler.cpp || die
	sed -i -e '/Externals\/glslang/s/.*/find_library(GLSLANG libglslang.a)\nfind_library(SPIRV libSPIRV.a)\nfind_library(OSDEPENDENT libOSDependent.a)\nfind_library(OGLCOMPILER libOGLCompiler.a)\nfind_library(SPVREMAPPER libSPVRemapper.a)\nfind_library(HLSL libHLSL.a)\nlist(APPEND LIBS ${GLSLANG} ${SPIRV} ${OSDEPENDENT} ${OGLCOMPILER} ${SPVREMAPPER} ${HLSL})/' CMakeLists.txt || die
	echo 'target_link_libraries(dolphin-emu PRIVATE ${GLSLANG} ${SPIRV} ${OSDEPENDENT} ${OGLCOMPILER} ${SPVREMAPPER} ${HLSL})' >> Source/Core/DolphinQt/CMakeLists.txt || die
	echo 'target_link_libraries(dolphin-nogui PRIVATE ${GLSLANG} ${SPIRV} ${OSDEPENDENT} ${OGLCOMPILER} ${SPVREMAPPER} ${HLSL})' >> Source/Core/DolphinNoGUI/CMakeLists.txt || die
	echo 'target_link_libraries(videovulkan PRIVATE ${GLSLANG} ${SPIRV} ${OSDEPENDENT} ${OGLCOMPILER} ${SPVREMAPPER} ${HLSL})' >> Source/Core/VideoBackends/Vulkan/CMakeLists.txt || die
	## Unbundle pugixml # cmake still wrongly notices bundle is used
	sed -i -e '/Externals\/pugixml/d' CMakeLists.txt || die

	# Preserve some bundled libraries
	# not in tree: cpp-optparse cubeb
	# custom     : picojson soundtouch
	# no unbundle: Bochs_disasm gtest
	mkdir externals
	for ext in Bochs_disasm cpp-optparse cubeb discord-rpc gtest picojson soundtouch; do
		mv Externals/${ext} externals || die
	done
	rm -r Externals || die "Failed to delete Externals dir."
	mv externals Externals || die
	use !discord && rm Externals/discord-rpc -r

	remove_locale() {
	   # Ensure preservation of the backup locale when no valid LINGUA is set
		if [[ "${PLOCALE_BACKUP}" == "${1}" ]] && [[ "${PLOCALE_BACKUP}" == "$(l10n_get_locales)" ]]; then
			return
		else
			rm "Languages/po/${1}.po" || die
		fi
	}

	l10n_find_plocales_changes "Languages/po/" "" '.po'
	l10n_for_each_disabled_locale_do remove_locale
}

src_configure() {
	local mycmakeargs=(
		-DENCODE_FRAMEDUMPS=$(usex ffmpeg ON OFF)
		-DENABLE_ALSA=$(usex alsa ON OFF)
		-DENABLE_ANALYTICS=$(usex web-report ON OFF)
		-DENABLE_BLUEZ=$(usex bluez ON OFF)
		-DUSE_DISCORD_PRESENCE=$(usex discord ON OFF)
		-DENABLE_EVDEV=$(usex evdev ON OFF)
		-DENABLE_HEADLESS=$(usex qt5 OFF ON)
		-DENABLE_LTO=$(usex lto ON OFF )
		-DENABLE_LLVM=$(usex llvm ON OFF )
		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON OFF )
		-DENABLE_QT=$(usex qt5 ON OFF )
		-DENABLE_SDL=$(usex sdl ON OFF )
		-DFASTLOG=$(usex log ON OFF )
		-DOPROFILING=$(usex profile ON OFF )
		-DUSE_EGL=$(usex egl ON OFF )
		-DUSE_UPNP=$(usex upnp ON OFF )
		-DUSE_SHARED_ENET=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc Readme.md
	if use doc; then
		dodoc -r docs/ActionReplay docs/DSP docs/WiiMote
	fi

	doicon -s 48 Data/dolphin-emu.png
	doicon -s scalable Data/dolphin-emu.svg
	doicon Data/dolphin-emu.svg
}

pkg_postinst() {
	# Add pax markings for hardened systems
	pax-mark -m "${EPREFIX}"/usr/games/bin/"${PN}"-emu
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
