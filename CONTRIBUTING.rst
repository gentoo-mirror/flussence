Overlay QA/coding standards, etc.
=================================

This is a collection of notes and reminders for myself:

Use ``pkgdev commit`` for all regular commits. If upstream provides release notes, try to remember
to add ``-T Upstream-Ref:$URL``.

Use ``git push``; the pre-commit hook does a superset of the checks ``pkgdev push`` would.

Changelog URLs in ``metadata.xml`` always point to an upstream RSS/Atom list of releases. This is a
wilful violation of Gentoo's spec, which has no way to specify machine-readable update URLs, because
I find it uselessly stiff. Running ``scripts/dump-feeds.raku`` will spit out an OPML list of these.
(OPML is an awful format, but nobody seems to have the will to promote an alternative.)
