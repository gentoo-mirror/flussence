# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: allarches.eclass
# @MAINTAINER:
# flussence <gentoo+bugs@flussence.eu>
# @AUTHOR:
# flussence <gentoo+bugs@flussence.eu>
# @SUPPORTED_EAPIS: 8
# @BLURB: Set keywords when the package itself doesn't care about architecture specifics
# @DESCRIPTION:
# The allarches eclass fills in KEYWORDS as broadly as possible and does nothing else.
# Inherit this class instead of hand-rolling a list that will inevitably become outdated.
# The current string was chosen by counting the number of occurrences in sec-keys/*::gentoo,
# and then fixed up to make pkgcheck not complain.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ALLARCHES_ECLASS} ]]; then
_ALLARCHES_ECLASS=1

KEYWORDS="alpha amd64 arm arm64 hppa loong ~m68k mips ppc ppc64 riscv s390 sparc x86"
fi
