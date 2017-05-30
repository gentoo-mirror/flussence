# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="OCBNET"
DIST_VERSION=3.4.6
inherit perl-module

DESCRIPTION="Compile .scss files using libsass"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Encode-Locale
	dev-perl/File-Slurp
	dev-perl/List-MoreUtils
	virtual/perl-Carp
	virtual/perl-Getopt-Long"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-CppGuess-0.090
	>=virtual/perl-ExtUtils-MakeMaker-6.520
	dev-perl/File-chdir
	test? (
		dev-perl/Test-Differences
		dev-perl/YAML-LibYAML
	)"

pkg_setup() {
	myconf=(
		"OPTIMIZE=${CFLAGS}"
		"LDFLAGS=${LDFLAGS} -lstdc++ -Wl,--no-as-needed"
	)
}
