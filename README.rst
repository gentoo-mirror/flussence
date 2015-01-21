============================================
The ``::flussence`` Gentoo ebuild repository
============================================

Some ebuilds I'm using or have used. There's patched versions of other people's
ebuilds, and a few I made myself because they didn't exist anywhere else at the
time.

All of these are supposed to work. If you find any problems with the ebuilds
themselves, or anything that doesn't look like an upstream bug, please take it
to the `Github Issues`_ page for this repository.

Requires an EAPI 5 (or higher) package manager.

Note that the 3-line legalese header on each ebuild is required to be present by
Gentoo's QA programs, and SHOULD NOT be construed as anything other than
`meaningless boilerplate`_. Correct attribution for ebuilds is in the git logs.

Contents
========

* ``dev-java/java-config-wrapper``:
  java-config-wrapper without the hardcoded Portage deps

  Modernized versions of Gentoo's Java scripts to play nice with other package
  managers, like ``perl-cleaner`` and ``python-updater`` already do. Doesn't
  support pkgcore yet; I'll add it if someone sends a patch.

  Also fixes `Bug 193305`_, `Bug 504124`_ and `Bug 505098`_, because they took
  about 10 seconds each to fix. This stuff is evidently abandonware.

* ``games-server/minecraft-common`` and ``games-server/minecraft-server``:
  Minecraft server ebuilds

  These are heavily modified/updated versions of the ebuilds in the `Java
  overlay`_ (which hadn't been updated since around 1.4). These support running
  from custom directories and don't spawn/depend on tmux (recent versions of the
  game support rcon).

  There are rumours of the Java overlay getting an up-to-date version of this
  soon, so this may become obsolete. Or it may not, depending on how well their
  version goes.

* ``games-util/c10t``:
  c10t_ git ebuild

  A minimal ebuild that builds/installs the "c10t" binary. Contains some
  self-written patches to hack light/height map rendering back in. Not sure if
  upstream is dead, this may stop working if it turns out not to be.

* ``media-video/get_iplayer``:
  get_iplayer

  This exists because the one in another overlay had a mandatory mplayer
  dependency and I'd switched to mpv.

* ``net-irc/irssi``:
  irssi git ebuild

  This is the ``::gentoo`` ebuild but with 300% added rice. Don't use it.

* ``sys-apps/kmscon`` and ``dev-libs/libtsm``:
  kmscon 8, and its libtsm dep

  Anti-aliased bloat for your consoles. Works but feels slightly buggy to me.

* ``sys-apps/s6``:
  s6 1.x

  A workaround for `Bug 529180`_ because both Gentoo and Paludis upstream hate
  their users or something.

  I gave up before I actually got to use this, and will probably drop it when
  2.0 is released.

* ``sys-process/runit``:
  runit 2.1.2

  A heavily improved runit ebuild, adopted after Gentoo failed to respond to
  multiple bugs for several months. Has a few nice additions like working
  virtual terminals, upstream-compatible filesystem layout, less environment
  pollution, and transparent kexec reboot support.

  N.B. all binaries are placed into ``/bin`` and ``/sbin``, to avoid
  manufacturing unnecessary problems regarding ``/usr`` as a separate
  mountpoint. Take note of the *elog* output if upgrading from a previously
  insane configuration,  as it may render your system unbootable without manual
  correction.

  See also my runit-scripts_ repository for replacements to some OpenRC
  initscripts.

  This runs all of my systems, and so I consider it to be production-quality.
  *DO NOT* file bugs on Gentoo sites about this ebuild or the scripts.

.. my stuff
.. _Github Issues: https://github.com/flussence/ebuilds/issues
.. _runit-scripts: https://github.com/flussence/runit-scripts

.. external links
.. _c10t: https://github.com/udoprog/c10t

.. gentoo stuff
.. _Bug 193305: https://bugs.gentoo.org/show_bug.cgi?id=193305
.. _Bug 504124: https://bugs.gentoo.org/show_bug.cgi?id=504124
.. _Bug 505098: https://bugs.gentoo.org/show_bug.cgi?id=505098
.. _Bug 529180: https://bugs.gentoo.org/show_bug.cgi?id=529180
.. _Java overlay: http://git.overlays.gentoo.org/gitweb/?p=proj/java.git;a=summary
.. _meaningless boilerplate: https://devmanual.gentoo.org/ebuild-writing/common-mistakes/index.html#missing/invalid/broken-header
