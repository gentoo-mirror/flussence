# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils eutils flag-o-matic perl-module toolchain-funcs

# Keep for _rc compability
MY_P="${P/_/-}"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
SRC_URI="http://irssi.org/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dane ipv6 +perl selinux ssl socks5 +proxy true-color"

# dnssec-validator 2.1 is missing val_dane_check(), and upstream's bug tracker is broken.
CDEPEND="
	>=dev-libs/glib-2.6.0
	dane? ( <net-dns/dnssec-validator-2.1[threads] )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )
	ssl? ( dev-libs/openssl )
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"
REQUIRED_USE="dane? ( ssl )"
S=${WORKDIR}/${MY_P}

src_prepare() {
	cd m4
	epatch "${FILESDIR}/${PN}-0.8.15-tinfo.patch"
	cd ..
	AUTOTOOLS_AUTORECONF=1
	autotools-utils_src_prepare
}

src_configure() {
	econf \
		--with-ncurses="${EPREFIX}"/usr \
		--with-perl-lib=vendor \
		--enable-static \
		$(use_with perl) \
		$(use_with proxy) \
		$(use_with socks5 socks) \
		$(use_enable dane) \
		$(use_enable ipv6) \
		$(use_enable ssl) \
		$(use_enable true-color)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	use perl && perl_delete_localpod

	prune_libtool_files --modules

	dodoc AUTHORS ChangeLog README.md TODO NEWS
}
