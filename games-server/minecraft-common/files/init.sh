#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

: ${multiverse:=${MULTIVERSE:-${RC_SVCNAME#*.}}}
: ${multiverse:=main}
: ${datadir:=${DATADIR:-/var/lib/minecraft}}
: ${rundir:=${RUNDIR:-/run/minecraft}}
: ${SSD_STARTWAIT:=3000}

PIDFILE="${rundir}/${multiverse}.pid"
SOCKET="/tmp/tmux-minecraft-${multiverse}"

depend() {
    need net
}

start() {
    local SERVER="${SVCNAME%%.*}"
    local EXE="/usr/games/bin/${SERVER}"
    local basedir="${datadir}/${multiverse}"

    ebegin "Starting Minecraft multiverse \"${multiverse}\" using ${SERVER}"

    if [ ! -x "${EXE}" ]; then
        eend 1 "${SERVER} was not found. Did you install it?"
        return 1
    fi

    # The server keeps this file opened while it's running, so we can find the PID from it.
    # It's a horrible hack but the previous logfile-based version broke between 14w21-14w27.
    local open_file="${basedir}"/*/region/r.0.0.mca

    if [ -f "${open_file}" ] && fuser -s "${open_file}"; then
        eend 1 "This multiverse appears to be in use, maybe by another server?"
        return 1
    fi

    checkpath -d -m 0750 -o root:games ${rundir}
    checkpath -d -m 0770 -o root:games ${datadir}

    # tmux support has been removed since vanilla now supports rcon.
    start-stop-daemon --start --background --make-pidfile \
        --pidfile ${PIDFILE} \
        --chdir "${basedir}" \
        --user games:games \
        --umask 027 \
        --exec "${EXE}" -- "${multiverse}" "${datadir}" < /dev/null

    eend $?
}

stop() {
    ebegin "Stopping Minecraft multiverse \"${multiverse}\""

    start-stop-daemon -K -p "${PIDFILE}"

    eend $?
}

_get_an_in_use_file() {
    local basedir=$1

    echo "${basedir}"/*/region/r.0.0.mca
}