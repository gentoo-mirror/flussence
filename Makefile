# order matters: do the faster one first
test: shellcheck pkgcheck

shellcheck:
	shellcheck --format=gcc */*/*.ebuild

pkgcheck:
	pkgcheck scan --staged --exit error,warning

.PHONY: test shellcheck pkgcheck
