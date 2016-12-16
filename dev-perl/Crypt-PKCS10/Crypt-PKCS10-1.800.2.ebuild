# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="TLHACKQUE"
DIST_VERSION=1.8002
inherit perl-module

DESCRIPTION="parse PKCS #10 certificate requests"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Socket
	>=dev-perl/Convert-ASN1-0.270
	>=dev-perl/Digest-MD2-2.30
	>=dev-perl/Digest-MD4-1.500
	>=virtual/perl-Digest-MD5-2.510
	>=virtual/perl-Digest-SHA-5.950
	virtual/perl-Encode
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}
	dev-perl/Pod-Readme
	>=virtual/perl-ExtUtils-MakeMaker-6.580
	>=virtual/perl-Text-Tabs+Wrap-2005.82.401
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)"
