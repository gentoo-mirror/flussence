# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils systemd

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/kmscon"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.xz"

LICENSE="MIT LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc drm fbdev +gles2 multiseat +pango pixman static-libs systemd udev unifont wayland"

COMMON_DEPEND="
	dev-libs/libtsm
	virtual/libudev
	x11-libs/libxkbcommon
	x11-libs/libdrm
	gles2? ( >=media-libs/mesa-8.0.3[egl,gbm,gles2] )
	pango? ( x11-libs/pango )
	pixman? ( x11-libs/pixman )
	systemd? ( sys-apps/systemd )"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="
	|| ( drm fbdev gles2 )
	multiseat? ( systemd )"

src_configure() {
	declare -a VIDEO FONTS RENDER=(bbulk)

	# Video backends
	use fbdev && VIDEO+=(fbdev)
	use drm   && VIDEO+=(drm2d)
	use gles2 && VIDEO+=(drm3d)

	# Font rendering backends
	use pango   && FONTS+=(pango)
	use unifont && FONTS+=(unifont)

	# Console rendering backends
	use gles2  && RENDER+=(gltex)
	use pixman && RENDER+=(pixman)

	# Squash those into comma-separated strings
	OLDIFS=$IFS
	IFS=","
	USE_VIDEO="${VIDEO[*]}"
	USE_FONTS="${FONTS[*]}"
	USE_RENDER="${RENDER[*]}"
	IFS=$OLDIFS

	econf \
		$(use_enable static-libs static) \
		$(use_enable udev hotplug) \
		$(use_enable debug) \
		$(use_enable multiseat multi-seat) \
		--htmldir=/usr/share/doc/${PF}/html \
		--with-video=$USE_VIDEO \
		--with-fonts=$USE_FONTS \
		--with-renderers=$USE_RENDER \
		--with-sessions=dummy,terminal \
		--enable-kmscon
}

src_install() {
	default

	systemd_dounit "${S}/docs"/kmscon{,vt@}.service

	prune_libtool_files
}
