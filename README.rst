Some ebuilds for Gentoo
=======================

Goals
-----

**Prompt updates**
  Upstream release Atom/RSS feeds are monitored so things aren't left outdated for months or years.

**Proactive QA**
  Ebuild checks are always done before publishing, not when someone else notices it's broken.

**Supply chain security**
  The repository itself has GPG signatures on all commits, and ``verify-sig.eclass`` is used
  whenever upstream provides anything to work with. The current hall of fame as of 2025:

  * ``sys-process/runit`` (GPG signatures)

  🙃

Feedback
--------

Send bug reports via the `Gentoo bug tracker <https://bugs.gentoo.org>`_ -
use product “Gentoo Linux”, component “Overlays” and prefix the subject line with ``[flussence]``.

Installing
----------

1. The “walled garden” method::

    # emerge -n eselect-repository
    # eselect repository enable flussence
    # emaint sync -r flussence

2. Direct setup::

    # cat > /etc/portage/repos.conf/flussence.conf <<EOF
    [flussence]
    location = /var/db/repos/flussence
    sync-type = git
    sync-uri = https://repo.or.cz/flussence-overlay.git
    sync-git-verify-commit-signature = true
    sync-openpgp-key-path = /usr/share/openpgp-keys/flussence.asc
    sync-openpgp-key-refresh = no
    EOF
    # emaint sync -r flussence
    # emerge sec-keys/openpgp-keys-flussence::flussence

   The last 3 config lines are optional and grant TOFU-level security, which is better than nothing.
   You should be suspicious of any ``sec-keys`` package or dependency change, and not just mine.

   ``emerge --sync`` will emit the following scary message each time because ``emerge`` does not
   understand that system-wide signing keys can be provisioned by ``emerge``. You can ignore it::

    * Using keys from /usr/share/openpgp-keys/flussence.asc
    * Key refresh is disabled via a repos.conf sync-openpgp-key-refresh
    * setting, and this is a security vulnerability because it prevents
    * detection of revoked keys!
    * Trusted signature found on top commit

   **Do not** set ``sync-openpgp-key-refresh=yes``. It adds no meaningful security, will slow down
   the sync process while it times out, and will also allow me to remotely detect your use of
   ``emerge --sync`` in realtime as a side effect.

Contents
--------

This list is manually maintained. Some things may be missing (accidentally or not).
For a complete list, do ``eix [-R] -c --in-overlay flussence``

``dev-perl/Crypt-LE`` — `Crypt::LE <https://metacpan.org/pod/Crypt::LE>`_
  A Perl ACME/Let's Encrypt client with minimal dependencies and no surprise third-party traffic.

``dev-perl/Regexp-Debugger`` — `Regexp::Debugger <https://metacpan.org/pod/Regexp::Debugger>`_
  The ``rxrx`` utility is an entire interactive TUI for watching a regex go through the motions.
  Also works as a perl module so you can drop into an interactive debugger mid-program.

``dev-qt/qtstyleplugins`` — `Qt5 Themes <https://code.qt.io/cgit/qt/qtstyleplugins.git/>`_
  Includes the old Qt4 default “Plastique”, and a mostly-working GTK+2 theme engine.
  This hasn't been maintained upstream since 2017, but surprisingly still works.
  Unfortunately it lacks the pinnacle of FOSS GUI design, Keramik.

``games-engines/dhewm3`` — `Doom 3 sourceport <https://dhewm3.org>`_
  Adds a bunch of modern QoL features - SDL2 joypad support, widescreen, etc.
  Good enough to play through the entire game without hitches.

``gnome-extra/gucharmap`` — `GTK+2 version of gucharmap <https://wiki.gnome.org/Apps/Gucharmap>`_
  The last released GTK+2 version of gucharmap, patched to recognise new Unicode characters.
  Strictly better than ``gnome-extra/gnome-characters`` (no Javascript, supports color emoji),
  and compared to ``kde-apps/kcharselect`` is significantly easier to navigate and less laggy.
  Make sure to p.mask ``gnome-extra/gucharmap::gentoo`` if you install this,
  or else the higher version number of that Gtk+3 dummy package will override it.

``media-fonts/tt2020`` — `Authentic typewriter font <https://fontlibrary.org/en/font/tt2020-base-style>`_
  A monospace font that uses OpenType alternate glyph tricks to give letters an analogue feel.
  This is a heavy download (same order of magnitude as ``media-fonts/noto``),
  but you can ``USE=minimal`` to get just the base font without variants.

``media-fonts/ubuntu-font-family`` — `The complete Ubuntu font <https://design.ubuntu.com/font/>`_
  Installs the most up-to-date version of Ubuntu, Ubuntu Mono, and Ubuntu Italic.
  These are modern variable fonts supporting arbitrary widths and weights.

``media-sound/audacious``, ``media-libs/audacious-plugins`` — `Audacious Media Player <https://audacious-media-player.org/>`_
  Actively tracks upstream development, supports all features from GTK+2 to Qt6, and does it right.
  If you want the best possible Audacious setup on Gentoo, use this.

  Also exposes plugins that make use of other packages:

  ``media-libs/adplug`` — `AdLib OPL2/3 software emulator <https://github.com/adplug/adplug>`_
    Old FM synth emulator for MIDI and MIDI-adjacent formats.
    Not necessary if you have other MIDI playback methods enabled, but here as an option.

  ``media-libs/libopenmpt`` — `Tracker module playback library <https://lib.openmpt.org/libopenmpt/>`_
    Module playback library and standalone player.
    Better accuracy and format support than libmodplug.

``media-sound/qpwgraph`` — `PipeWire Graph Qt GUI Interface <https://gitlab.freedesktop.org/rncbc/qpwgraph>`_
  Graphical patchbay for PipeWire, directly descended from QJackCtl.
  Allows you to connect inputs and outputs manually and save/restore connection sets.

``net-dns/agnos`` — `ACME client in Rust <https://github.com/krtab/agnos>`_
  A mostly automated tool to get subdomain wildcard certificates (using an internal dns-01 server),
  only needing a minor static addition to your server's main DNS zone.

``sys-apps/udev-hid-bpf`` — `Method and apparatus for patching input devices <https://libevdev.pages.freedesktop.org/udev-hid-bpf/>`_
  Enables loading user-specified BPF blobs into the kernel to work around bugs in HID devices.
  Very niche purpose, but it's here for those who need it.

``sys-kernel/zenergy`` — `Ryzen power hwmon driver <https://github.com/BoukeHaarsma23/zenergy>`_
  This is a fork of the old ``amd_energy`` driver, which was removed from the kernel in a hurry after
  someone realised having joule-accurate counters made a Meltdown-like attack possible. This version
  fuzzes the numbers just enough to stymie that while allowing mundane meter-reading to still work.

``sys-process/runit`` — `Runit PID1 and service manager <http://smarden.org/runit/>`_
  The init system I'm using since 2014.
  This package tracks vanilla upstream as of 2.2.0, previously Void Linux.
  By default requires OpenRC for bringup and shutdown, but this is easily swappable by the sysadmin.

``www-plugins/passff-host`` — `PassFF host application <https://codeberg.org/PassFF/passff#readme>`_
  Installs a python script necessary for PassFF to work.
  Updated fork of the unmaintained 1.2.4 found in ``::gentoo`` with added support for LibreWolf.

``x11-base/wayback`` — `A simple and modern X11 server <https://github.com/kaniini/wayback>`_
  This runs Xwayland with full privileges on a bare wlroots compositor.
  It is intended to be a replacement for ``x11-base/xorg-server``.

``x11-libs/gtk+:3`` — `debloated Gtk+3 <https://forums.gentoo.org/viewtopic-p-8245612.html#8245612>`_
  Contains a NetBSD patch which makes DBus (and auto-spawning of hidden DBus processes) optional.
  This ebuild usually has zero-day updates before ::gentoo gets them.

``x11-misc/gcolor2`` — `GTK+2 colour picker <https://gcolor2.sourceforge.net>`_
  Culled from ::gentoo in 2022 as part of their crusade to rid the world of stable software.
  The replacement, GColor3, which they didn't even package as a courtesy, is extremely bad.

``x11-themes/qt6gtk2`` — `GTK+2 themes in Qt6 <https://github.com/trialuser02/qt6gtk2>`_
  If you're not satisfied with the selection of Qt6-native and Gtk3 themes, give this a try.
  Does not play nice with hi-dpi screens, but should still be usable.

``x11-misc/picom`` — `standalone X11 compositor <https://github.com/yshui/picom>`_
  This is a distant descendant of the original xcompmgr.
  Supports xrender and OpenGL 3+ with user-defined shaders.

Copyright
---------
The permissible format of ebuild headers seems to change constantly and so trying to put a precise
copyright notice in them is more effort than it's worth.

If you're just an end user you don't have to care about this,
but for files wholly my own work, GPL2-or-later is granted::

    SPDX-License-Identifier: GPL-2+

    Copyright © 2012-<current year> flussence <flussence+K.bE3w31BjB8@flussence.eu>

    This is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

*****

Reach heaven through violence 💚🏳️‍⚧️
