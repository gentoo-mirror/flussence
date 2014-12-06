============================================
The ``::flussence`` Gentoo ebuild repository
============================================

Some packages of varying quality. I use many of these regularly; if you have any
problems send them to the `Github Issues`_ page for this repository.

Requires an EAPI 5 (or higher) package manager.

Note that the 3-line legalese header on each ebuild is required to be present by
Gentoo's QA programs, and SHOULD NOT be construed as anything other than
`meaningless boilerplate`_.

Contents
========

* ``games-server/minecraft-common`` and ``games-server/minecraft-server``:
  Minecraft Vanilla server 1.8

  These are heavily modified/updated versions of the ebuilds in the `Java
  overlay`_, which support running from custom directories and don't
  spawn/depend on tmux (recent versions of the game support rcon).

  There are rumours of the Java overlay getting an up-to-date version of this
  soon, so this may become obsolete.

* ``games-util/c10t``: c10t_ git ebuild

  A minimal ebuild that builds/installs the "c10t" binary. Contains some
  self-written patches to hack light/height map rendering back in.

* ``media-video/get_iplayer``: get_iplayer 2.90

  This exists because the one in another overlay had a mandatory mplayer
  dependency and I'd switched to mpv.

* ``sys-apps/kmscon`` and ``sys-libs/libtsm``: kmscon 8, and its libtsm dep

  Anti-aliased bloat for your consoles. Works but feels slightly buggy to me.

* ``sys-apps/s6``

  A workaround for `Bug 529180`_.

* ``sys-process/runit``: runit 2.1.2

  I'm using this ebuild for PID 1 on all of my systems, and consider it to be
  production-quality.

  N.B. all binaries are placed into ``/bin`` and ``/sbin``, to avoid
  manufacturing unnecessary problems regarding ``/usr`` as a separate
  mountpoint. Take note of the *elog* output when installing.

  See also my runit-scripts_ repository for replacements to some OpenRC
  initscripts.

.. my stuff
.. _Github Issues: https://github.com/flussence/ebuilds/issues
.. _runit-scripts: https://github.com/flussence/runit-scripts

.. external links
.. _c10t: https://github.com/udoprog/c10t

.. gentoo stuff
.. _Bug 529180: https://bugs.gentoo.org/show_bug.cgi?id=529180
.. _Java overlay: http://git.overlays.gentoo.org/gitweb/?p=proj/java.git;a=summary
.. _meaningless boilerplate: https://devmanual.gentoo.org/ebuild-writing/common-mistakes/index.html#missing/invalid/broken-header
