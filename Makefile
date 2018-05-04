test:
	find . -name '*.ebuild' -exec shellcheck -f gcc -s bash -e SC2034 \{} +
	repoman full
	# SC2034 is "unused variable"; too many false positives

.PHONY: test
