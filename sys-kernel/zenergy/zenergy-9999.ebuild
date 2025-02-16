# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="BoukeHaarsma23"

DESCRIPTION="AMD Zen CPU RAPL power meter hwmon driver"

LICENSE="GPL-2"
SLOT="0"

inherit github-pkg linux-mod-r1

CONFIG_CHECK="HWMON PCI AMD_NB"

src_compile() {
	local modlist=(zenergy)
	linux-mod-r1_src_compile
}
