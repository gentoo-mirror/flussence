# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="LEADER"
inherit perl-module

DESCRIPTION="Let's Encrypt API interfacing module."

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Crypt-Format
	dev-perl/Crypt-OpenSSL-Bignum
	dev-perl/Crypt-OpenSSL-PKCS10
	dev-perl/Crypt-OpenSSL-RSA
	dev-perl/Crypt-PKCS10
	virtual/perl-Digest-SHA
	virtual/perl-HTTP-Tiny
	dev-perl/IO-Socket-SSL
	dev-perl/JSON-MaybeXS
	dev-perl/Log-Log4perl
	virtual/perl-MIME-Base64
	virtual/perl-Module-Load
	dev-perl/Net-SSLeay
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-Piece"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)"
