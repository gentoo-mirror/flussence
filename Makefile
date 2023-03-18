# order matters: do the faster one first
test: shellcheck pkgcheck

shellcheck:
	shellcheck */*/*.ebuild

pkgcheck:
	pkgcheck scan --staged --exit error,warning

nitpick:
	shellcheck --enable=all --exclude=SC2154 */*/*.ebuild
	pkgcheck scan --exit error,warning

.PHONY: test nitpick shellcheck pkgcheck
.IGNORE: nitpick
