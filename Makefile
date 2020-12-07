test:
	# SC2034 (vars set but unused): too many false positives
	shellcheck --format=gcc --shell=bash --exclude=SC2034 */*/*.ebuild

longtest: test test-pkgcheck test-repoman

test-repoman:
	repoman full

# pkgcheck does not set a sane error code, so this one always succeeds
test-pkgcheck:
	pkgcheck scan

.PHONY: test longtest test-repoman test-pkgcheck
