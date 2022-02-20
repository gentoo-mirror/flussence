Some ebuilds for Gentoo
=======================

These are my packages for things that:

* aren't in the main Gentoo tree at all,
* aren't as up-to-date as I'd like there,
* aren't maintained to a sufficient standard in the main tree.

All commits are signed by a GPG key, available via WKD, for the email address output from:
```raku
#!/usr/bin/env rakudo
my $name = 'flussence-overlay'.subst('-overlay', '');
put $name ~ '@' ~ $name ~ '.eu';
```

Packages that install arch-independent stuff will be keyworded for non-exotic arches only:
x86/amd64, arm/arm64, mips and ppc/ppc64.

Installing
----------
If you know what you're doing, go right ahead. Otherwise:

    root # emerge -n eselect-repository
    root # eselect repository enable flussence

Contents
--------
This list is manually maintained. Some things may be missing (accidentally or not).
For a complete list, do `eix [-R] -c --in-overlay flussence`

`dev-perl/Crypt-LE` — [Crypt::LE](https://metacpan.org/pod/Crypt::LE)
: A Perl ACME/Let's Encrypt client with lightweight dependencies.
  Not the most user-friendly option, but it has minimal dependencies,
  and unlike `app-crypt/acme-sh` it doesn't secretly require CloudFlare.
  Current version supports ECC certs, wildcards and ACME API v2.

`dev-perl/Regexp-Debugger` — [Regexp::Debugger](https://metacpan.org/pod/Regexp::Debugger)
: The `rxrx` utility, a lifesaver when trying to figure out what a Perl regex is doing.

`dev-qt/qtstyleplugins` — [Qt5 Themes](https://code.qt.io/cgit/qt/qtstyleplugins.git/)
: Includes the old Qt4 default, “Plastique”, and a mostly-working GTK+2 theme engine.
  This hasn't been maintained upstream since 2017, but surprisingly still works.
  Unfortunately lacks the pinnacle of FOSS GUI design, Keramik.

`games-action/minecraft-launcher` — Java launcher for Minecraft
: Convenience ebuild that installs the good Minecraft launcher (not the awful Electron-based one).

`games-*/ut2004-*` — UT2004 binaries and map packs via IPFS
: A historical data preservation effort using IPFS, as an alternative to the Gentoo repo ebuilds.
  While those currently have a working `SRC_URI`, they've spent a lot of their life on thin ice
  and were nearly removed in 2019 (a lot of other `games-fps/*` ebuilds didn't make the cut).
  SHA1 hashes are also listed in `metadata.xml`, to facilitate in scavenging the web for copies.

`gnome-extra/gucharmap` — GTK+2 version of gucharmap
: The last released GTK+2 version of gucharmap, patched to recognise new Unicode characters.
  Contains far fewer dependencies than the current GNOME 3 version forces upon you,
  and is significantly easier to navigate and less laggy than `kde-apps/kcharselect` (as of 21.08)
  Make sure to p.mask `gnome-extra/gucharmap::gentoo` if you install this,
  or else the higher version number of the GTK+3 one will override it.

`media-fonts/tt2020` — [Authentic typewriter font](https://fontlibrary.org/en/font/tt2020-base-style)
: A monospace font that uses OpenType alternate glyph tricks to give letters an analogue feel.
  This is a heavy download, but you can `USE=minimal` to get just the base font without variants.

`media-libs/libopenmpt` — [OpenMPT playback library](https://lib.openmpt.org)
: A modern replacement for modplug and mikmod.
  Much wider format support, more accurate playback, and better security upkeep.
  Supported by `media-sound/audacious` since late 2019.

`media-sound/audacious` — [Audacious Media Player](https://audacious-media-player.org/)
: This ebuild actively tracks upstream development. Gentoo's ebuild has half-decade open bugs.
  If you want the best possible Audacious setup on Gentoo, possibly any distro, use this.

`media-plugins/lvis` — [Audacious visualiser plugin](https://git.sr.ht/~kaniini/lvis)
: An Audacious visualiser plugin. Like Winamp AVS, but better.

`net-misc/streamlink` — [Web livestream extracting tool](https://streamlink.github.io/)
: [Outdated in ::gentoo](https://bugs.gentoo.org/800860)

`sys-process/runit` — [Runit PID1 and service manager](http://smarden.org/runit/)
: An elegant init for a more civilised age. (S6 is good too)
  This package is a hard fork of whatever was in the Gentoo tree circa 2014,
  which was full of unfixed bugs and didn't have a responsible maintainer.
  It does things slightly differently, so familiarise yourself before use; `qlist` is your friend.
  There is no handholding here. There may be in future.

`x11-libs/gtk+:3` — debloated Gtk+3
: Contains a NetBSD patch which makes DBus (and auto-spawning of hidden DBus processes) optional.
  Patch is from [a f.g.o thread](https://forums.gentoo.org/viewtopic-p-8245612.html#8245612)

`x11-misc/picom` — [standalone X11 compositor](https://github.com/yshui/picom)
: This is a distant descendant of the original xcompmgr.
  Supports xrender and OpenGL 3+ with user-defined shader capabilities.

IPFS mirrors
------------
Some of these ebuilds use [IPFS](https://ipfs.io) in addition to (or instead of) regular mirrors.
You can use your local IPFS gateway by adding it to `/etc/portage/mirrors`, e.g.:

    ipfs http://localhost:8080/

*Note:* If unconfigured, the default list for `mirror://ipfs/` URLs includes CloudFlare.

If you have the resources to run an IPFS node, please consider adding your own distfiles to it.
IPFS hash URLs in this overlay were generated using go-ipfs-0.4.15 defaults, so do the same.

For reference, those defaults are equivalent to:

    ipfs add --hash sha2-256 --chunker size-262144 $file

Copyright
---------
Due to distro technical debt and office politics, ebuild headers have to carry a GPL2-only statement
without full attribution. I disagree with this, but don't have the resources to fix it.

For files wholly my own work (figuring this out is on you), GPL2-or-later is granted:

    SPDX-License-Identifier: GPL-2+

    Copyright © 2012-2020 flussence <flussence+Q7diI0FN8k7o@flussence.eu>

    This is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
