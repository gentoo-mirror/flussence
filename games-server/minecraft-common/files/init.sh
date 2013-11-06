#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

extra_started_commands="console"

: ${multiverse:=${MULTIVERSE:-${RC_SVCNAME#*.}}}
: ${multiverse:=main}
: ${datadir:=${DATADIR:-/var/lib/minecraft}}
: ${rundir:=${RUNDIR:-/run/minecraft}}

PIDFILE="${rundir}/${multiverse}.pid"
SOCKET="/tmp/tmux-minecraft-${multiverse}"

depend() {
    need net
}

start() {
    local SERVER="${SVCNAME%%.*}"
    local EXE="/usr/games/bin/${SERVER}"

    ebegin "Starting Minecraft multiverse \"${multiverse}\" using ${SERVER}"

    if [ ! -x "${EXE}" ]; then
        eend 1 "${SERVER} was not found. Did you install it?"
        return 1
    fi

    # The server keeps this file opened while it's running, so we can find the PID from it
    local logdir="${datadir}/${multiverse}/logs"
    local logfile="${logdir}/latest.log"
    local lockfile="${logdir}/startup.lock"

    if [ -f "${logfile}" ] && fuser -s "${logfile}"; then
        eend 1 "This multiverse appears to be in use, maybe by another server?"
        return 1
    fi

    checkpath -d -m 0750 -o root:games ${rundir}
    checkpath -d -m 0770 -o root:games ${datadir}

    mark_service_starting

    touch "${lockfile}"

    local cmd="umask 027 && '${EXE}' '${multiverse}' '${datadir}'"
    su -c "/usr/bin/tmux -S '${SOCKET}' new-session -n 'minecraft-${multiverse}' -d \"${cmd}\"" \
          games

    if ewaitfile 15 "${logfile}"; then
        until is_newer_than "${logfile}" "${lockfile}"; do
            sleep 1
        done

        fuser "${logfile}" > "${PIDFILE}" 2> /dev/null
        mark_service_started
        eend 0
    else
        eend 1
    fi

    rm "${lockfile}"
}

stop() {
    ebegin "Stopping Minecraft multiverse \"${multiverse}\""

    # tmux will automatically terminate when the server does.
    start-stop-daemon -K -p "${PIDFILE}" && rm -f "${SOCKET}"

    eend $?
}

console() {
    exec /usr/bin/tmux -S "${SOCKET}" attach-session
}
