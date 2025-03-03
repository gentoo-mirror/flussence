# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# There's a copy of this also in Fedora's repos if needed, but it's not the same file.
KEYGRIP_LONG="C2839ECAD9408FBE9531C3E9F434A1EFAFEEAEA3"

DESCRIPTION="OpenPGP keys used to sign LibreOffice source tar.xz files"
HOMEPAGE="
	https://www.libreoffice.org/
	https://src.fedoraproject.org/rpms/libreoffice/blob/f38/f/gpgkey-C2839ECAD9408FBE9531C3E9F434A1EFAFEEAEA3.gpg.asc"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${KEYGRIP_LONG}
		-> ${P}-${KEYGRIP_LONG}.asc"
S="${WORKDIR}"
LICENSE="public-domain"
SLOT="0"

inherit allarches

src_install() {
	local files=( "${A}" )
	insinto /usr/share/openpgp-keys
	newins - "${PN##*-}.asc" < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
