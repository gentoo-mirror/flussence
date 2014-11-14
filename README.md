# The `::flussence` Gentoo ebuild repository

Some packages of decent quality. These all work for me; if you have any problems
send them [here][gh-issues].

Requires an EAPI 5 (or higher) package manager.

## Contents

* `games-server/minecraft-common` and `games-server/minecraft-server`:
  Minecraft Vanilla server 1.8

  These are heavily modified/updated versions of the ebuilds in the
  [`::java`][java] overlay, which support running from custom directories and
  don't spawn/depend on tmux (recent versions of the game support rcon).

* `games-util/c10t`: [c10t][c10t] git ebuild

  A minimal ebuild that builds/installs the "c10t" binary. Needs improvement.

* `media-sound/pulseaudio`

  This is just a workaround for [Bug 519530][bgo519530], though I've been using
  it before that was filed. This ebuild should go away eventually.

* `media-video/get_iplayer`: get_iplayer 2.86

  This exists because the one in another overlay had a mandatory mplayer
  dependency and I'd switched to mpv.

* `sys-apps/kmscon` and `sys-libs/libtsm`: kmscon 8, and its libtsm dep

  Anti-aliased bloat for your consoles. Works but feels slightly buggy to me.

* `sys-apps/s6`

  Another workaround, this time for [Bug 529180][bgo529180].

* `sys-process/runit`: runit 2.1.2

  I'm using this ebuild for PID 1 on all of my systems, and consider it to be
  production-quality.

  Logging in on console [works][bgo522204], as does [shutdown][bgo521918].

  N.B. all binaries are placed into `/bin` and `/sbin`, to avoid manufacturing
  unnecessary problems regarding `/usr` as a separate mountpoint. Take note of
  the *elog* output when installing.

  See also my [runit-scripts][runit-scripts] repository for replacements to some
  OpenRC initscripts.

[bgo519530]: https://bugs.gentoo.org/show_bug.cgi?id=519530
[bgo521918]: https://bugs.gentoo.org/show_bug.cgi?id=521918
[bgo522204]: https://bugs.gentoo.org/show_bug.cgi?id=522204
[bgo522786]: https://bugs.gentoo.org/show_bug.cgi?id=522786
[bgo529180]: https://bugs.gentoo.org/show_bug.cgi?id=529180
[c10t]: https://github.com/udoprog/c10t
[gh-issues]: https://github.com/flussence/ebuilds/issues
[java]: http://git.overlays.gentoo.org/gitweb/?p=proj/java.git;a=summary
[runit-scripts]: https://github.com/flussence/runit-scripts
