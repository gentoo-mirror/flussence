# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# After a few stabs in the dark (a lot of public keyservers reject short IDs,
# and the link on $HOMEPAGE is dead) i tried the Ubuntu keyserver and it had the
# full key. Makes sense for a Debian developer in hindsight…
KEYGRIP_LONG="DAC43860630556B6DBF0898FA5DAAEFCB14D13CC"

DESCRIPTION="OpenPGP keys used by Gerrit Pape"
HOMEPAGE="https://smarden.org/pape/"
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
	newins - gerritpape.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
