# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static +symlink sysv-compat"

# Prevent automatic upgrades to force people to pay attention to elog stuff
DEPEND="!!<sys-process/runit-2.1.2-r4
	sysv-compat? ( !sys-apps/sysvinit )"

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
	if use sysv-compat; then
		dosbin "${FILESDIR}"/poweroff
		dosbin "${FILESDIR}"/reboot
	fi

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
	elog "If this is your first time installing runit, some manual setup is"
	elog "required before you can use it as your primary init system."
	elog "'agetty' services have been installed in /etc/sv/, but they are not"
	elog "enabled automatically. Symlink one or more of these into "
	elog "/etc/service/ to have console logins available at boot."
	elog "The supplied startup scripts will run up to OpenRC's 'boot' runlevel"
	elog "and then start runit's services."
	echo
	elog "/service will be a symlink to /etc/service iff you have USE=symlink."
	elog "This is only used to allow 'sv stat foo' shorthand to work; you may"
	elog "also define \$SVDIR for the same effect."
	if [[ ${REPLACING_VERSIONS} ]] ; then
		echo
		ewarn "A pre-existing runit version was detected."
		ewarn "You may want to verify your /etc/service setup is sane."
	fi
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		ewarn "runit was uninstalled. Make sure your system is still bootable!"
	fi
}
