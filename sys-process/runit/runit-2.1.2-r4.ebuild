# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static +symlink"

# Prevent automatic upgrades to force people to pay attention to elog stuff
DEPEND="!!<sys-process/runit-2.1.2-r4"

S=${WORKDIR}/admin/${P}/src

src_prepare() {
	# we either build everything or nothing static
	sed -i -e 's:-static: :' Makefile
}

src_configure() {
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	dodir /etc/service
	use symlink && dosym /etc/service /service

	into /
	dobin chpst runsv runsvchdir runsvdir sv svlogd
	dosbin runit runit-init utmpset
	into /usr

	for tty in agetty-tty{1..6}; do
		exeinto /etc/sv/$tty/
		for script in run finish; do
			newexe "${FILESDIR}"/${script}.agetty $script
		done
	done

	exeinto /etc/runit
	doexe "${FILESDIR}"/{1,3,ctrlaltdel}

	# N.B. this is not $WORKDIR, $S is redefined above
	cd "${S}"/..

	sed -i 's@/service@/etc/service@' etc/2 || die 'sed failed'
	doexe etc/2

	dodoc package/{CHANGES,README,THANKS,TODO}
	dohtml doc/*.html
	doman man/*.[18]
}

pkg_postinst() {
	elog "We've installed some agetty scripts into /etc/sv/, but not enabled them by default."
	elog "If you want these to start at boot, create symlinks in /etc/service/ manually."
	elog
	elog "This version of the runit ebuild uses a more upstream/FHS-friendly layout:"
	elog "  /etc/runit/runsvdir/all --> /etc/sv"
	elog "  /etc/runit/runsvdir/current (and /var/service symlink) --> /etc/service"
	elog "If you have USE=symlink, /service will be a symlink to /etc/service. This replaces the"
	elog "former method of defining \$SVDIR globally via /etc/env.d/."
	elog "See the discussion in #522786 for more info."
	if [[ ${REPLACING_VERSIONS} ]] ; then
		ewarn "You should migrate your services to /etc/sv/ *NOW*."
	fi
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		ewarn "runit was uninstalled. Make sure your system is still bootable!"
	fi
}
