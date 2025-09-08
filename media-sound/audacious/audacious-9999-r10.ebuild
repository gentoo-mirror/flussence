# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD-2 BSD CC-BY-SA-4.0"
SLOT="0/5.5.0"
IUSE="+cli gtk2 gtk3 libarchive +qt6"

if [[ ${PV} == "9999" ]]; then
	# This ebuild revision is for c7539c5bba or later
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
	inherit verify-sig
	SRC_URI+=" verify-sig? ( ${SRC_URI%%.tar*}.sha256sum )"
fi

inherit meson xdg

REQUIRED_USE="|| ( cli gtk2 gtk3 qt6 )"

RDEPEND="
	>=dev-libs/glib-2.32
	cli? ( sys-apps/dbus )
	libarchive? ( app-arch/libarchive )
	gtk2? (
		>=x11-libs/gtk+-2.24:2
		x11-libs/cairo
		x11-libs/pango
		virtual/libintl
	)
	gtk3? (
		!gtk2? (
			>=x11-libs/gtk+-3.22:3
			x11-libs/cairo
			x11-libs/pango
			virtual/libintl
		)
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
	)"
DEPEND="${RDEPEND} virtual/pkgconfig"
BDEPEND="
	sys-devel/gettext
	cli? ( dev-util/gdbus-codegen )"
PDEPEND="~media-plugins/audacious-plugins-${PV}[gtk2(-)?,gtk3(-)?,qt6(-)?]"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	elif use verify-sig; then
		pushd "${DISTDIR}" || die
		verify-sig_verify_unsigned_checksums "${A##* }" sha256 "${A%% *}"
		popd || die
	fi

	default
}

src_configure() {
	local repository emesonargs

	# i quote from ebuild(5): "You may use this for whatever you like."
	repository="$(sed -nE '/Repository: \w+$/ { s/.*\s(\w+)$/\1/p;q }' "${T}/build.log" || true)"
	emesonargs=(
		"-Dbuildstamp='${CATEGORY}/${PF}${repository:+::}${repository}'"
		"--auto-features=disabled"
		"$(meson_use "$(usex gtk2 gtk2 gtk3)" gtk)"
		"$(meson_use qt6 qt)"
		"$(meson_use cli dbus)"
		"$(meson_use gtk2)"
		"$(meson_use libarchive)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# install useful files from contrib/
	insinto /usr/share/metainfo
	doins contrib/audacious.appdata.xml

	insinto /usr/share/Thunar/sendto/
	newins {contrib/thunar-sendto-,}audacious-playlist.desktop

	use cli && dodoc contrib/xchat-audacious.py
}

pkg_preinst() {
	xdg_pkg_preinst

	# make sure this matches, or else we'll create preserved-libs litter
	test -e "${D}"/usr/lib*/libaudcore.so."${SLOT##*/}" ||
		eqawarn "Subslot in ebuild needs updating"
}
