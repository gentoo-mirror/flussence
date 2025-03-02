# order matters: do the faster one first
test: shellcheck pkgcheck

shellcheck:
	shellcheck */*/*.ebuild

shellcheck_harsh:
	shellcheck --enable=all --exclude=SC2154 */*/*.ebuild

pkgcheck:
	pkgcheck scan --staged --exit error,warning

pkgcheck_harsh:
	# AcctCheck just breaks without manual configuration
	pkgcheck scan --exit error,warning --checksets all --checks=-AcctCheck

nitpick: shellcheck_harsh pkgcheck_harsh

.PHONY: test nitpick shellcheck shellcheck_harsh pkgcheck pkgcheck_harsh
.IGNORE: nitpick
