# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="frankcrawford"

DESCRIPTION="Fork of the kernel's it87.ko with support for more chips"
LICENSE="GPL-2"
SLOT="0"

inherit github-pkg linux-mod-r1

CONFIG_CHECK="HWMON PCI"

src_compile() {
	local modlist=(it87)
	local modargs=( KERNEL_BUILD="${KV_OUT_DIR}" )
	linux-mod-r1_src_compile
}
