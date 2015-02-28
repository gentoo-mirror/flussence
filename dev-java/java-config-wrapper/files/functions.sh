#!/bin/bash

. /lib/gentoo/functions.sh

# This kind of abstraction should probably be a package of its own.
case "$PACKAGE_MANAGER" in
	'' )
		eerror "Please use 'eselect package-manager' to set your PM!"
		exit 1
		;;

	portage )
		QFILE="${ROOT}/usr/bin/qfile"
		# Prints full package with version, i.e. can be passed straight to emerge below
		print_owning_spec() {
			echo "=$(${QFILE} -C -q -v $1)"
		}
		reinstall_spec() {
			emerge --oneshot $1
		}
		print_overlay_dirs() {
			portageq get_repo_path ${ROOT:-/} \
				$(portageq get_repos ${ROOT:-/})
		}
		;;

	paludis )
		CAVE="${ROOT}/usr/bin/cave"
		print_owning_spec() {
			${CAVE} print-spec --in-repository '' \
				$(${CAVE} print-owners -f '%u' $1)
		}
		reinstall_spec() {
			cave resolve --preserve-world --execute $1
		}
		print_overlay_dirs() {
			for repo in $(cave print-repositories --format e); do
				cave print-repository-metadata --raw-name location --format '%v\n' $repo
			done
		}
		;;

	pkgcore | * )
		eerror "$PACKAGE_MANAGER isn't supported by $0 yet, sorry."
		exit 1
		;;
esac
