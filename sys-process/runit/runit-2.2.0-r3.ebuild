# Copyright 2014-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic readme.gentoo-r1 toolchain-funcs verify-sig

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz
	verify-sig? ( https://smarden.org/runit/sha256sum.asc -> ${P}.sha256sum.asc )"
S="${WORKDIR}/admin/${P}/src"
LICENSE="BSD"
SLOT="0/vanilla"
KEYWORDS="~amd64 ~x86"
IUSE="static verify-sig"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gerritpape.asc
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gerritpape )"

# runtime dependencies in /etc/runit/{1,3}
RDEPEND="
	sys-apps/openrc
	sys-process/psmisc
"

PATCHES=( "${FILESDIR}"/bug721880-dont-hardcode-ar-ranlib.patch )

src_unpack() {
	if use verify-sig; then
		pushd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"${P}".sha256sum.asc sha256 "${P}".tar.gz
		popd || die
	fi

	default
}

src_prepare() {
	default

	# No half measures: USE=static determines whether everything or nothing is built static.
	sed -i -e 's:-static: :' Makefile
}

src_configure() {
	# build failures with gcc15 (std=gnu23)
	append-cflags "-std=gnu11"
	use static && append-ldflags "-static"

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld # [sic]
	tc-getAR     > conf-ar
	tc-getRANLIB > conf-ranlib
}

src_install() {
	cd "${S}/.." || die

	# Install documentation.
	DOCS=( package/{CHANGES,README,THANKS} )
	HTML_DOCS=( doc/*.html )
	einstalldocs
	doman man/*.[18]
	readme.gentoo_create_doc

	# Install runit-init stages
	exeinto "/etc/runit"
	doexe "${FILESDIR}/stages/"*
	for rc_dir in rc.{1..3}; do
		exeinto "/etc/runit/${rc_dir}"
		doexe "${FILESDIR}/${rc_dir}/"*
	done

	# Install the example other-distro scripts as reference material.
	docinto examples
	dodoc -r etc/2 etc/*/
	# …and our own agetty one
	docinto examples/gentoo/agetty
	# this slightly awkward dance is to avoid using newdoc, which does the same worsely
	mkdir "${T}"/agetty
	for script in finish run; do
		cp "${FILESDIR}/${script}.agetty" "${T}/agetty/${script}"
		dodoc "${T}/agetty/${script}"
	done

	# Tell runit programs and shell completions where our services live.
	# The "standard" dir is /service, and every distro rightfully ignores it.
	dodir /etc/service
	newenvd - "99${PN}" <<- EOF
		# /etc/env.d/99${PN}
		SVDIR="/etc/service"
	EOF

	cd "${S}" || die

	# Install compiled binaries
	into /
	dobin chpst runsv runsvchdir runsvdir sv svlogd
	dosbin runit runit-init utmpset
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -n ${REPLACING_VERSIONS} ]] ; then
		ewarn "A pre-existing runit version was detected."
		ewarn "This package no longer installs agetty scripts to /etc/sv/"
		ewarn "You may want to verify your /etc/service setup is sane."
	fi
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		ewarn "${P} was uninstalled. Make sure your system is still bootable!"
	fi
}
