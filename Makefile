test:
	# Ignoring SC2034 (variables defined but not set): too many false positives
	find . -name '*.ebuild' -exec shellcheck -f gcc -s bash -e SC2034 \{} +
	repoman full

.PHONY: test
