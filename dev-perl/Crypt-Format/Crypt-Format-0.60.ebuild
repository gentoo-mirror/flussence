# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="FELIPE"
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Conversion utilities for encryption applications"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=virtual/perl-MIME-Base64-0.10"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.580
	test? (
		>=dev-perl/Test-Exception-0.40
		>=virtual/perl-Test-Simple-0.440
	)"
