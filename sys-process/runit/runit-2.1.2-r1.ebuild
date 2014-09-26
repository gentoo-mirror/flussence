# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="static"

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
	dosym default /etc/runit/runsvdir/current
	dosym ../etc/runit/runsvdir/current /var/service

	into /
	dobin chpst runsv runsvchdir runsvdir sv svlogd
	dosbin runit runit-init utmpset
	into /usr

	# make sv command work
	cat <<-EOF > 20runit
		#/etc/env.d/20runit
		SVDIR="/var/service/"
	EOF
	doenvd 20runit

	for tty in agetty-tty{1..6}; do
		exeinto /etc/runit/runsvdir/all/$tty/
		for script in run finish; do
			newexe "${FILESDIR}"/${script}.agetty $script
		done
	done

	exeinto /etc/runit
	doexe "${FILESDIR}"/{1,3,ctrlaltdel}

	# N.B. $S is redefined above
	cd "${S}"/..

	sed -i 's@/service@/var/service@' etc/2 || die 'sed failed'
	doexe etc/2

	dodoc package/{CHANGES,README,THANKS,TODO}
	dohtml doc/*.html
	doman man/*.[18]
}

pkg_postinst() {
	elog "/etc/profile was updated to define SVDIR. If you want 'sv' service"
	elog "name shortcuts to work in your currently open shells, run:"
	elog "$ source /etc/profile"
	elog "(You can still interact with them by specifying the full path.)"

	# We don't do this by default, in case the user's customised their setup to
	# run mingetty, kmscon or etc.
	if [[ ${REPLACING_VERSIONS} ]] ; then
		elog ""
		elog "Reinstalling, not reactivating any agetty services. To do that"
		elog "manually, run this command (or just symlink them yourself):"
		elog "# emerge --config =${CATEGORY}/${PF}"
	else
		pkg_config
	fi
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		ewarn "runit was uninstalled. Make sure your system is still bootable!"
	fi
}

pkg_config() {
	elog "Setting up default agetty services on tty1-6"
	for tty in agetty-tty{1..6}; do
		dosym ../all/$tty ${ROOT}/etc/runit/runsvdir/default/$tty
	done
}
