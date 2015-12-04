# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="A lightweight Perl 6-like environment for virtual machines"
HOMEPAGE="https://github.com/perl6/nqp"
EGIT_REPO_URI="https://github.com/perl6/nqp.git"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java +moar"
REQUIRED_USE="|| ( java moar )"

RDEPEND="java? ( virtual/jdk )
	moar? ( dev-lang/moarvm )"
DEPEND="${DEPEND}
	>=dev-lang/perl-5.10"

src_configure() {
	declare -a BACKENDS
	local IFS=","

	# The order of this list determines which gets installed as "nqp"
	use moar && BACKENDS+=(moar)
	use java && BACKENDS+=(jvm)

	perl Configure.pl --prefix=/usr \
		--backends=$BACKENDS
}
