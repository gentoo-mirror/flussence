#!/usr/bin/env perl6
use Net::Minecraft::Version;

sub MAIN {
    my Pair $current = get-current-ebuild;
    my $current-vstr = Version.new($current.key).parts[0,1].join;

    my $newest = get-versions<latest><snapshot>;
    my $newest-vstr = do given $newest {
        # "15w48b" style weekly
        when /^ (\d ** 2) w (\d ** 2) (\w) $/ {
            sprintf('%02d%02d%s', @($/));
        }
        # "1.9-pre1" style prerelease
        when /^ \d+ '.' \d+ '-pre' \d+ $/ {
            .subst: |<- _>;
        }
        default {
            ??? $_
        }
    }

    say "$current-vstr is the current version ({$current.value})";
    say "$newest-vstr is the newest version ({server-jar-for($newest)})";

    say 'Current looks newest; exiting' and exit
        if $current-vstr eq $newest-vstr;

    my @cmd = flat
        <git mv>,
        ~$current.value,
        ~$current.value.parent.child("minecraft-server-{$newest-vstr}.ebuild");

    note "Would run: {@cmd.perl}";

    exit unless prompt('Update? [y/N] ') ~~ rx:i{^y[es]?};

    run(|@cmd) or die q{Couldn't git mv (dirty working copy?)};
    chdir(get-repo-dir);
    run(<repoman manifest>) or die q{repoman failed (FIX IT)};
    run(<git commit -a>);
}

sub get-repo-dir() returns IO::Path {
    $*PROGRAM.parent.parent;
}

sub get-ebuild-dir() returns IO::Path {
    # This is _still_ horrible.
    my $dir = get-repo-dir;
    $dir.=child($_) for <games-server minecraft-server>;
    $dir.=cleanup(:parent);
    $dir;
}

sub get-current-ebuild() returns Pair #`(version number => filehandle) {
    my Regex $test = rx/'minecraft-server-' (\d\d\d\d\w) '.ebuild'$/;

    my $ebuild-dir = get-ebuild-dir();

    my $ebuild = $ebuild-dir.dir(:$test).cache;

    die qq{Expected one ebuild but you have $ebuild}
        if $ebuild.elems != 1;

    $_ => $ebuild[0]
        with $ebuild.match($test)[0];
}
