# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtstyleplugins"
inherit qt5-build

DESCRIPTION="Additional style plugins for Qt"
HOMEPAGE="https://code.qt.io/cgit/qt/qtstyleplugins.git/"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0"
RESTRICT="test" # Automagically added qttest-5.9999 dependency doesn't exist

if [[ ${PV} == *9999 ]]; then
	EGIT_BRANCH="master"
else
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

pkg_postinst() {
	ewarn "Trying to select the GTK2 theme in qt5ct will crash it!"
	ewarn "To test whether the themes look acceptable run e.g.:"
	ewarn "    QT_QPA_PLATFORMTHEME=gtk2 programname"
}
