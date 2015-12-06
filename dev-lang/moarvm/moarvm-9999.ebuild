# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="A 6model-based VM for NQP and Rakudo Perl 6"
HOMEPAGE="http://moarvm.org"
EGIT_REPO_URI="https://github.com/MoarVM/MoarVM.git"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# These deps may be too strict, but it's what I have installed at the time
RDEPEND=">=dev-libs/libatomic_ops-7.4.2
	>=dev-libs/libffi-3.2.1
	>=dev-libs/libtommath-0.42.0-r1
	>=dev-libs/libuv-1.4.2"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10"

src_configure() {
	perl Configure.pl --prefix=/usr \
		--has-libtommath \
		--has-libuv \
		--has-libatomic_ops
}
