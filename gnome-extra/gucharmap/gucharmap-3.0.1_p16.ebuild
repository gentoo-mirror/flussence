# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_ORG_MODULE="gucharmap"
GNOME_ORG_PV="${PV%%_p*}"
GNOME_TARBALL_SUFFIX="bz2"
inherit flag-o-matic gnome2 verify-sig

MY_UV="${PV##*_p}" # app-i18n/unicode-data major version that we support.
# N.B. "15", not "15.1". For an upstream ".1" just -r bump this file and edit
# the defines patch. i'm aware this sucks but version parsing tricks is worse

DESCRIPTION="GNOME Character Map, based on the Unicode Character Database"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"
SRC_URI+=" verify-sig? ( ${SRC_URI%%.tar*}.sha256sum )"
LICENSE="GPL-3 unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc nls +system-unicode"

RDEPEND="
	>=dev-libs/glib-2.16.3
	>=x11-libs/gtk+-2.14.0:2"
DEPEND="${RDEPEND}"
BDEPEND="
	system-unicode? (
		>=dev-lang/perl-5.28.0
		=app-i18n/unicode-data-${MY_UV}*
	)"

PATCHES=( "${FILESDIR}"/unicode-"${MY_UV}"-defines.patch )

src_unpack() {
	if use verify-sig; then
		pushd "${DISTDIR}" || die
		verify-sig_verify_unsigned_checksums "${A##* }" sha256 "${A%% *}"
		popd || die
	fi

	default
}

src_prepare() {
	gnome2_src_prepare

	if use system-unicode; then
		cd -- "${S}"/gucharmap || die
		rm unicode-{blocks,names{,list},unihan,categories,scripts,versions}.h
		perl "${FILESDIR}"/gen-guch-unicode-tables.pl
	fi
}

src_configure() {
	# gucharmap-chartable-cell-accessible.h needs fixing but I don't know how
	append-cflags "-Wno-incompatible-pointer-types"
	gnome2_src_configure --with-gtk=2.0 --disable-gconf "$(use_enable nls)"
}

src_install() {
	# avoid slot 2.90 clashes by renaming the binary
	sed -i -e 's/Exec=gucharmap/\0-legacy/' -e 's/=Character Map/\0 (legacy)/' \
		gucharmap.desktop || die

	gnome2_src_install

	mv "${D}"/usr/bin/gucharmap{,-legacy} || die
	mv "${D}"/usr/share/applications/gucharmap{,-legacy}.desktop || die

	# these are probably legacy², and we're better off removing them to avoid confusion
	rm "${D}"/usr/bin/{charmap,gnome-character-map} || die
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn "${PF} now installs the application as /usr/bin/gucharmap-legacy"
		ewarn "to avoid file collisions with ${PN}:2.90. Please verify your shortcuts still work."
	fi
}
