# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="JONOZZZ"
inherit perl-module

DESCRIPTION="Perl extension to OpenSSL's PKCS10 API."

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Crypt-OpenSSL-RSA"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
