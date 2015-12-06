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
# TODO: add USE="java javascript" here once those backends are in working order
IUSE="+moar test"
REQUIRED_USE="|| ( moar )"

RDEPEND="moar? ( dev-lang/moarvm )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10"

src_configure() {
	declare -a BACKENDS
	local IFS=","

	# The order of this list determines which gets installed as "nqp", and
	# rakudo inherits it, so it's sorted by stability.
	use moar && BACKENDS+=(moar)
	#use java && BACKENDS+=(jvm)
	#use javascript && BACKENDS+=(js)

	perl Configure.pl --prefix=/usr \
		--backends=$BACKENDS
}