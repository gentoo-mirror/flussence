# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# i'm just copy-pasting what sec-keys/*::gentoo does here.
# this seems cargo-culty but there's no eclass and it seems to be how they do it, so whatever
DESCRIPTION="OpenPGP keys used by flussence (::flussence overlay)"
HOMEPAGE="https://repo.or.cz/flussence-overlay.git"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/BF8150A33570C29211E154D75B523D41E6753775
		-> flussence-BF8150A33570C29211E154D75B523D41E6753775.asc
"
S="${WORKDIR}"
LICENSE="public-domain"
SLOT="0"

inherit allarches

src_install() {
	local files=( "${A}" )
	insinto /usr/share/openpgp-keys
	newins - flussence.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
