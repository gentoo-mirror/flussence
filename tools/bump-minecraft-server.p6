#!/usr/bin/env perl6
use lib $*PROGRAM-NAME.IO.parent.child('lib'); # is this really such a good idea
use Minecraft::VersionCheck;

sub MAIN {
    my Pair $current = get-current-snapshot;
    say "{$current.key} is the current version ({$current.value})";

    my Pair $newest = get-newest-snapshot;
    say "{$newest.key} is the newest version ({$newest.value})";

    say 'Current looks newest; exiting' and exit
        if ~$current.key ge ~$newest.key;

    exit unless prompt('Update? [y/N] ') ~~ rx:i{^y[es]?};

    given $current.value {
        run(<git mv>,
            .Str,
            .parent.child("minecraft-server-{$newest.key.join}.ebuild")
        );
    }

    chdir(get-repo-dir);
    run(<repoman manifest>);
    run(<git commit -a>);
}

sub get-repo-dir() returns IO::Path {
    $*PROGRAM-NAME.IO.parent.parent;
}

sub get-ebuild-dir() returns IO::Path {
    # This is _still_ horrible.
    my $dir = get-repo-dir;
    $dir.=child($_) for <games-server minecraft-server>;
    $dir.=cleanup(:parent);
    $dir;
}

sub get-current-snapshot() returns Pair #`(version number bits => filehandle) {
    my Regex $ebuild-name = rx/'minecraft-server-' (\d\d)(\d\d)(\w) '.ebuild'$/;

    my $ebuild-dir = get-ebuild-dir();

    my $ebuild = $ebuild-dir.dir(test => $ebuild-name);

    die qq{You shouldn't have more than one $ebuild-name in here}
        if $ebuild.elems != 1;

    my $version = $ebuild.Str.match($ebuild-name).list.item;

    return $version => $ebuild[0];
}
