# Copyright 2016-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6 # restricted by perl-module.eclass

DIST_AUTHOR="LEADER"
inherit perl-module

DESCRIPTION="Let's Encrypt API module and client"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Convert-ASN1-0.200
	>=dev-perl/Crypt-OpenSSL-Bignum-0.60
	>=dev-perl/Crypt-OpenSSL-RSA-0.280
	virtual/perl-Digest-SHA
	virtual/perl-File-Temp
	>=virtual/perl-HTTP-Tiny-0.42
	>=dev-perl/IO-Socket-SSL-1.420
	>=dev-perl/JSON-MaybeXS-1.3.5
	>=dev-perl/Log-Log4perl-1.270
	>=virtual/perl-MIME-Base64-3.110
	>=virtual/perl-Module-Load-0.160
	>=dev-perl/Net-SSLeay-1.490
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Time-Piece-1.270"
# Module-Build is duplicated due to a perl-module.eclass bug
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380"
BDEPEND="
	>=virtual/perl-ExtUtils-Install-1.460
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.380
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)"
