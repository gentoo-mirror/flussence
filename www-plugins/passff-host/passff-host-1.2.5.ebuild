# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{{10..13},13t} )

inherit python-single-r1

DESCRIPTION="Native Messaging Host app for the PassFF WebExtension"
HOMEPAGE="https://codeberg.org/PassFF/passff-host"

SRC_URI="
	https://codeberg.org/PassFF/passff-host/releases/download/${PV}/passff.py -> ${P}.py
	https://codeberg.org/PassFF/passff-host/releases/download/${PV}/passff.json -> ${P}.json
"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-crypt/pinentry
"

src_unpack() {
	cp "${DISTDIR}/${P}."{json,py} . || die
}

src_prepare() {
	default
	python_fix_shebang "${P}.py"
}

src_install() {
	exeinto "/usr/libexec/${PN}"
	newexe "${P}.py" passff.py

	sed "s;PLACEHOLDER;/usr/libexec/${PN}/passff.py;g" "${P}.json" > passff.json || die
	insinto "/usr/share/${PN}"
	doins passff.json

	local target_prefixes=(
		# Firefox
		/usr/"$(get_libdir)"/mozilla
		# firefox-bin
		/usr/lib/mozilla
		# Librewolf
		/usr/"$(get_libdir)"/librewolf
		# Chrome
		/etc/opt/chrome
		# Chromium
		/etc/chromium
		# Vivaldi
		/etc/vivaldi
		# Mullvad Browser not included here because they didn't document an OS-level install path
	)

	for target in "${target_prefixes[@]}"; do
		dosym -r "/usr/share/${PN}/passff.json" "${target}/native-messaging-hosts/passff.json"
	done
}

pkg_postinst() {
	elog "Make sure to use graphical version of pinentry for ${PN} to work properly"
	elog "Run 'eselect pinentry list'"
	elog "And select 'pinentry-qt5' or 'pinentry-gnome'. efl might work too."
}
