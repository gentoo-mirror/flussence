test:
	# SC2034 (vars set but unused): too many false positives
	shellcheck --format=gcc --shell=bash --exclude=SC2034 */*/*.ebuild
	repoman full

.PHONY: test
