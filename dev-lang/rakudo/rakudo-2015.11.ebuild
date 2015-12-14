# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A compiler for the Perl 6 programming language"
HOMEPAGE="http://rakudo.org"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/rakudo/rakudo.git"
	inherit git-r3
else
	SRC_URI="${HOMEPAGE}/downloads/rakudo/${P}.tar.gz"
fi

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: add USE="java javascript" once those are usable in nqp
IUSE="doc +moar test"
REQUIRED_USE="|| ( moar )"

RDEPEND="=dev-lang/nqp-${PV}*[moar?]"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10"

src_configure() {
	declare -a BACKENDS
	local IFS=","

	# The order of this list determines which gets installed as "perl6"
	use moar && BACKENDS+=(moar)
	#use java && BACKENDS+=(jvm)
	#use javascript && BACKENDS+=(js)

	perl Configure.pl --prefix=/usr --sysroot=/usr \
		--backends=$BACKENDS
}
