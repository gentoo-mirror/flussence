# order matters: do the faster one first
test: shellcheck pkgcheck

shellcheck:
	shellcheck */*/*.ebuild

shellcheck_harsh:
	shellcheck --enable=all --exclude=SC2154 */*/*.ebuild

pkgcheck:
	pkgcheck scan --staged

pkgcheck_all:
	pkgcheck scan

nitpick: shellcheck_harsh pkgcheck_all

.PHONY: test nitpick shellcheck shellcheck_harsh pkgcheck pkgcheck_all
.IGNORE: nitpick
