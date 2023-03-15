# Copyright 2016-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="LEADER"
inherit perl-module

DESCRIPTION="Let's Encrypt API module and client"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Convert-ASN1-0.200
	>=dev-perl/Crypt-OpenSSL-Bignum-0.60
	>=dev-perl/Crypt-OpenSSL-RSA-0.280
	virtual/perl-Digest-SHA
	virtual/perl-Encode
	>=virtual/perl-Getopt-Long-2.330
	>=virtual/perl-HTTP-Tiny-0.42
	>=dev-perl/IO-Socket-SSL-1.420
	>=dev-perl/JSON-MaybeXS-1.3.5
	>=dev-perl/Log-Log4perl-1.270
	>=virtual/perl-MIME-Base64-3.110
	>=virtual/perl-Module-Load-0.280
	>=dev-perl/Net-SSLeay-1.550
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	>=virtual/perl-Time-Piece-1.270"
BDEPEND="
	>=virtual/perl-ExtUtils-Install-1.460
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.422
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)"
