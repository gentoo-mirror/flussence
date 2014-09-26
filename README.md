# The `::flussence` Gentoo ebuild repository

Some packages of decent quality.

## Contents

* `games-server/minecraft-common` and `games-server/minecraft-server`

  Heavily modified versions of the files in [the `::java` overlay][java]. These
  support running from custom directories and don't spawn a tmux session (recent
  versions of the game support rcon).

* `media-sound/pulseaudio`

  This is a workaround for [Bug 519530][bgo519530], though I've been using it
  before that was filed.

* `media-video/get_iplayer`

  get_iplayer 2.86. Tries to have sane, optional dependencies.

* `sys-apps/kmscon` and `sys-libs/libtsm`

  kmscon 8.

* `sys-process/runit`

  runit 2.1.2.

  If you want to use runit as an init, I *strongly* recommend you try this over
  the Gentoo-supplied ebuild due to potentially system-breaking bugs and an
  unresponsive maintainer, who I've heard from the forums is also a systemd
  pusher.

  This fixes the following, and then some:

  * [Bug 521918][bgo521918]
  * [Bug 522204][bgo522204]
  * [Bug 522786][bgo522786]

  See also my [runit-scripts][runit-scripts] repository.

[java]: http://git.overlays.gentoo.org/gitweb/?p=proj/java.git;a=summary
[bgo519530]: https://bugs.gentoo.org/show_bug.cgi?id=519530
[bgo521918]: https://bugs.gentoo.org/show_bug.cgi?id=521918
[bgo522204]: https://bugs.gentoo.org/show_bug.cgi?id=522204
[bgo522786]: https://bugs.gentoo.org/show_bug.cgi?id=522786
[runit-scripts]: https://github.com/flussence/runit-scripts
