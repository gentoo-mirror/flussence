#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# These all-caps vars can be overridden by conf.d.
# RC_SVCNAME is automatically set from filename extension, same as in the net.* initscripts.
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

    # The server always keeps the spawn area loaded while running. The log files are also an option,
    # but those have broken in snapshots before.
    if fuser -s "${basedir}"/*/region/r.0.0.mca 2> /dev/null; then
        eend 1 "This multiverse appears to be in use, maybe by another server?"
        return 1
    fi

    checkpath -d -m 0750 -o root:games ${rundir}
    checkpath -d -m 0770 -o root:games ${datadir}

    # Vanilla MC now supports rcon, so we can do away with all the tmux stuff. The server is still
    # fairly stupid and tries to attach to stdin, so we need to give it /dev/null here to avoid
    # breaking the current terminal.
    start-stop-daemon --start --background --make-pidfile \
        --pidfile ${PIDFILE} \
        --chdir "${basedir}" \
        --user games:games \
        --umask 027 \
        --exec "${EXE}" -- "${multiverse}" "${datadir}" </dev/null

    eend $?
}

stop() {
    ebegin "Stopping Minecraft multiverse \"${multiverse}\""

    start-stop-daemon -K -p "${PIDFILE}"

    eend $?
}
