# order matters: do the faster one first
test: shellcheck pkgcheck

pkgcheck:
	pkgcheck scan --exit error,warning

shellcheck:
	# SC2034 (vars set but unused): too many false positives
	shellcheck --format=gcc --shell=bash --exclude=SC2034 */*/*.ebuild

.PHONY: test pkgcheck shellcheck
