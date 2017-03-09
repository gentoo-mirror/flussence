# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools perl-module git-r3

EGIT_REPO_URI="git://github.com/irssi/irssi.git"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="boehm-gc bot ipv6 libressl +perl +ncurses selinux ssl socks5 +proxy true-color"

CDEPEND="
	>=dev-libs/glib-2.6.0
	boehm-gc? ( dev-libs/boehm-gc )
	ncurses? ( sys-libs/ncurses:5 )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	>=sys-devel/autoconf-2.58
	dev-lang/perl
	|| (
		www-client/lynx
		www-client/elinks
	)"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"

PATCHES=(${FILESDIR}/${PN}-0.8.15-tinfo.patch)

src_prepare() {
	sed -i -e /^autoreconf/d autogen.sh || die
	NOCONFIGURE=1 ./autogen.sh || die

	eautoreconf
	default
}

src_configure() {
	econf \
		--with-ncurses="${EPREFIX}"/usr \
		--with-perl-lib=vendor \
		--enable-static \
		$(use_with bot) \
		$(use_with boehm-gc gc) \
		$(use_with ncurses textui) \
		$(use_with perl) \
		$(use_with proxy) \
		$(use_with socks5 socks) \
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
