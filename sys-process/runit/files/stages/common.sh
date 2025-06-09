#!/bin/sh
# /etc/runit/common.sh - generic code shared between runit stages
#
# This is intended to be symlinked as /etc/runit/{1..3}, and from there will run
# stage-specific tasks in /etc/runit/rc./{00..99}* (with the u+x bit set).

# Common variables. As small as possible, but no smaller.
LC_ALL="C.UTF-8"
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/usr/bin:/bin"
RC_PID="$$"
RC_STAGE="${1:-${0##*/}}" # command arg if given, basename (1..3) if not
export LC_ALL PATH RC_PID RC_STAGE

# Log a message purely for informational purposes.
echo "Entering runit stage ${RC_STAGE} at PID ${RC_PID}" | tee /dev/kmsg

# Two loops here to figure out the last loop iteration. Maybe there's a more
# elegant way to do this, but this is fine.
for rcfile in /etc/runit/rc."${RC_STAGE}"/[0-9][0-9]*; do
    test -x "${rcfile}" || continue
    runlast="${rcfile}"
done
for rcfile in /etc/runit/rc."${RC_STAGE}"/[0-9][0-9]*; do
    # The last item is exec'd into directly to keep the process tree small.
    test "${rcfile}" = "${runlast}" && exec "${runlast}"

    "${rcfile}"

    # Propagate exit codes in the supervision magic number range (1xx).
    # Use with caution: 100 in particular will induce runit to skip stage 2.
    # Exits ≥ 128 include generic segfaults and are ignored.
    exit_code=$?
    test 100 -le "${exit_code}" -a "${exit_code}" -le 127 &&
        exit "${exit_code}"
done

# If we're here then nothing was actually ran above.
echo "Nothing executable was found, this is bad. Trying a rescue shell instead."
exec /sbin/sulogin
