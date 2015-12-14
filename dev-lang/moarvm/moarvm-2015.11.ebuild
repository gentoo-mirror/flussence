# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A 6model-based VM for NQP and Rakudo Perl 6"
HOMEPAGE="http://moarvm.org"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/MoarVM/MoarVM.git"
	inherit git-r3
else
	MY_P="MoarVM-${PV}"
	SRC_URI="${HOMEPAGE}/releases/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+system-libatomic_ops system-libtommath +system-libuv"

# These deps may be too strict, but it's what I have installed at the time.
# Note that the bundled libtommath has patches that have been sent upstream,
# but aren't in any released version; 0.42 will compile but causes slight bugs.
RDEPEND="system-libatomic_ops? ( >=dev-libs/libatomic_ops-7.4.2 )
	>=dev-libs/libffi-3.2.1
	system-libtommath? ( >=dev-libs/libtommath-0.42 )
	system-libuv? ( >=dev-libs/libuv-1.4.2 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10"

src_configure() {
	perl Configure.pl --prefix=/usr \
		$(usex system-libatomic_ops "--has-libatomic_ops") \
		$(usex system-libtommath    "--has-libtommath") \
		$(usex system-libuv         "--has-libuv")
}
