# order matters: do the faster one first
test: shellcheck pkgcheck

shellcheck:
	shellcheck */*/*.ebuild

pkgcheck:
	pkgcheck scan --staged --exit error,warning

nitpick:
	shellcheck --enable=all --exclude=SC2154 */*/*.ebuild
	# AcctCheck just breaks without manual configuration
	pkgcheck scan --exit error,warning --checksets all --checks=-AcctCheck

.PHONY: test nitpick shellcheck pkgcheck
.IGNORE: nitpick
