# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHRISN
DIST_VERSION=1.88
DIST_EXAMPLES=("examples/*")
inherit multilib perl-module

DESCRIPTION="Perl extension for using OpenSSL"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl test minimal examples"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			dev-perl/Test-Exception
			dev-perl/Test-Warn
			dev-perl/Test-NoWarnings
		)
		virtual/perl-Test-Simple
	)
"
export OPTIMIZE="$CFLAGS"
export OPENSSL_PREFIX="${EPREFIX}"/usr

PATCHES=(
	"${FILESDIR}/${PN}-fix-libdir.patch"
	"${FILESDIR}/${PN}-fix-network-tests.patch"
)
PERL_RM_FILES=(
	# Hateful author tests
	't/local/01_pod.t'
	't/local/02_pod_coverage.t'
	't/local/kwalitee.t'
	# Broken under FEATURES="network-sandbox"
	# https://rt.cpan.org/Ticket/Display.html?id=128207
	't/local/06_tcpecho.t'
	't/local/07_sslecho.t'
)

src_configure() {
	if use test && has network "${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}"; then
		NETWORK_TESTS=yes
	else
		use test && einfo "Network tests will be skipped without DIST_TEST_OVERRIDE=~network"
		NETWORK_TESTS=no
	fi
	LIBDIR=$(get_libdir)
	export NETWORK_TESTS LIBDIR

	perl-module_src_configure
}
