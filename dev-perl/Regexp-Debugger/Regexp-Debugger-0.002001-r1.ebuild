# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6 # restricted by perl-module.eclass

DIST_AUTHOR="DCONWAY"
inherit perl-module

DESCRIPTION="Perl module and command line tool (rxrx) to visually debug regexes in-place"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

# People may find JSON::XS offputting. Install it manually if you want it.
RDEPEND="
	!minimal? (
		dev-perl/TermReadKey
		virtual/perl-Time-HiRes
	)"
# Module-Build is duplicated due to a perl-module.eclass bug
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-version"
BDEPEND="
	dev-perl/Module-Build
	virtual/perl-ExtUtils-MakeMaker"
