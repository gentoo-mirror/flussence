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

* ``games-util/c10t``: c10t_ git ebuild

  A minimal ebuild that builds/installs the "c10t" binary. Needs improvement.

* ``media-sound/pulseaudio``

  This is just a workaround for `Bug 519530`_, though I've been using
  it before that was filed. This ebuild should go away eventually.

* ``media-video/get_iplayer``: get_iplayer 2.86

  This exists because the one in another overlay had a mandatory mplayer
  dependency and I'd switched to mpv.

* ``sys-apps/kmscon`` and ``sys-libs/libtsm``: kmscon 8, and its libtsm dep

  Anti-aliased bloat for your consoles. Works but feels slightly buggy to me.

* ``sys-apps/s6``

  Another workaround, this time for `Bug 529180`_.

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
.. _Bug 519530: https://bugs.gentoo.org/show_bug.cgi?id=519530
.. _Bug 529180: https://bugs.gentoo.org/show_bug.cgi?id=529180
.. _Java overlay: http://git.overlays.gentoo.org/gitweb/?p=proj/java.git;a=summary
.. _meaningless boilerplate: https://devmanual.gentoo.org/ebuild-writing/common-mistakes/index.html#missing/invalid/broken-header
