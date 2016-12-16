# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="LEADER"
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="Let's Encrypt API interfacing module."

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Crypt-Format-0.20
	>=dev-perl/Crypt-OpenSSL-Bignum-0.60
	>=dev-perl/Crypt-OpenSSL-PKCS10-0.150
	>=dev-perl/Crypt-OpenSSL-RSA-0.280
	>=dev-perl/Crypt-PKCS10-1.500
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
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-Install-1.460
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.380
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)"
