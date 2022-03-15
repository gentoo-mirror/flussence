# Overlay QA/coding standards, etc.

This is a collection of notes and reminders for myself:

Use `pkgdev commit`; this autocorrects the `Manifest` files and fills in the
commit message usefully. If it's a version bump with an upstream news item of
note, then add `-T Upstream-Ref:$URL`

Don't bother using `pkgdev push` over `git push`, the pre-commit hook already
runs its tests (and more besides).

Changelog URLs in `metadata.xml` always point to an upstream RSS/Atom list of
releases. This is a wilful violation of Gentoo's spec, which has no way to
specify machine-readable update URLs, because I find it uselessly stiff. Running
`scripts/dump-feeds.raku` will spit out an OPML list of these.
