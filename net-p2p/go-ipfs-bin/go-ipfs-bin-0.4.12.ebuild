# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="go-ipfs is the main implementation of IPFS."
HOMEPAGE="https://ipfs.io/"

MY_PV="${PV/_/-}"
SRC_URI="
	amd64? ( mirror://ipfs/ipns/dist.ipfs.io/go-ipfs/v${MY_PV}/go-ipfs_v${MY_PV}_linux-amd64.tar.gz )
	x86? ( mirror://ipfs/ipns/dist.ipfs.io/go-ipfs/v${MY_PV}/go-ipfs_v${MY_PV}_linux-386.tar.gz )
	arm? ( mirror://ipfs/ipns/dist.ipfs.io/go-ipfs/v${MY_PV}/go-ipfs_v${MY_PV}_linux-arm.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~arm ~x86 ~amd64"
IUSE="+fuse"

RDEPEND="fuse? ( sys-fs/fuse )"
S="${WORKDIR}/go-ipfs"

QA_PREBUILT="/usr/bin/ipfs"

src_install() {
	dobin ipfs
}
