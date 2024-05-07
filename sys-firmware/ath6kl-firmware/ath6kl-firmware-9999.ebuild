# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="qca"

DESCRIPTION="ath6kl firmware images (AR6004)"
LICENSE="qca-firmware"
SLOT="0"

inherit github-pkg

src_install() {
	insinto /lib/firmware
	doins -r ath6k
	default
}
