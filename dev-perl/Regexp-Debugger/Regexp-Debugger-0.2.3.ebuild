# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DCONWAY"
DIST_VERSION="0.002003"
inherit perl-module eutils

DESCRIPTION="Perl module and command line tool (rxrx) to visually debug regexes in-place"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="minimal"

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

pkg_postinst() {
	# People may find JSON::XS's whole aesthetic offputting, so install it manually if you want it.
	# This also supports JSON::DWIW but that isn't packaged
	elog "${PN} has optional runtime dependencies:"
	optfeature "JSON output" dev-perl/{JSON{-XS,},YAML-Syck}
}
