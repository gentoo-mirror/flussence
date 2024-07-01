# Copyright 2014-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="void-linux"

DESCRIPTION="The fork of runit used as Void Linux's primary init system"
LICENSE="BSD"
SLOT="0/void"
IUSE="static"

inherit flag-o-matic github-pkg readme.gentoo-r1 shell-completion toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	S="${WORKDIR}/${P}/src"
else
	KEYWORDS="~amd64 ~x86"
	declare -A commit_map=(
		# current HEAD in upstream as of 2024-06-17
		[20220214]="2b8000f1ebd07fd68ee0e3c32737d97bcd1687fb"
	)
	EGIT_COMMIT="${commit_map[${PV##*_p}]}"
	SRC_URI="${GITHUB_HOMEPAGE}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}/src"
fi

# runtime dependencies of /etc/runit/{1,3}
RDEPEND="
	sys-apps/openrc
	sys-process/psmisc
"

PATCHES=( "${FILESDIR}"/bug721880-dont-hardcode-ar-ranlib.patch )

src_prepare() {
	default

	# No half measures: USE=static determines whether everything or nothing is built static.
	sed -i -e 's:-static: :' Makefile

	# Fix completion to actually respect SVDIR
	sed -i -e 's@/var/service@$''{SVDIR:-/var/service}@' ../completions/sv.bash
}

src_configure() {
	use static && append-ldflags "-static"
	# GCC≥14 workaround. It's a really bad one, but the only one currently within my ability.
	append-cflags "-fpermissive"

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld # [sic]
	tc-getAR     > conf-ar
	tc-getRANLIB > conf-ranlib
}

src_install() {
	cd "${S}/.." || die

	# Install documentation.
	DOCS=( package/{CHANGES,README,THANKS,TODO} )
	HTML_DOCS=( doc/*.html )
	einstalldocs
	doman man/*.[18]
	readme.gentoo_create_doc
	newbashcomp completions/sv.bash sv
	newzshcomp completions/sv.zsh sv

	# Install OpenRC runit-init stages.
	stage_dir=/lib/runit/stages/openrc
	exeinto "${stage_dir}"
	dosym -r "${stage_dir}" /etc/runit/current
	for script in 1 2 3 ctrlaltdel; do
		doexe "${FILESDIR}/${script}"
		dosym "current/${script}" "/etc/runit/${script}"
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
