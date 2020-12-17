#!/usr/bin/env perl6
use Net::Minecraft::Version;

my Regex $snapshot      = /^(\d ** 2) w (\d ** 2) (\w)$/;
my Regex $snapshot-fn   = / \d ** 4 \w /; #= e.g. minecraft-server-1816a.ebuild
my Regex $prerelease    = /^\d+ '.' \d+ '-pre' \d+$/;
my Regex $prerelease-fn = / \d+ '.' \d+ '_pre' \d+ /; #= e.g. minecraft-server-1.12_pre.ebuild

sub MAIN {
    my ($current, $current-file) = get-current-ebuild().kv;
    say "$current is the current version ($current-file)";

    my $newest    = get-versions()<latest><snapshot>;
    my $newest-fn = do given $newest {
        when $snapshot   { sprintf('%02d%02d%s', @($/)) }
        when $prerelease { .subst: |<- _> }
        default { ??? $_ }
    }

    say "$newest is the newest version ({server-jar-for($newest)})";

    say 'Current looks newest; exiting' and exit
        if $current eq $newest-fn;

    my @cmd = flat
        <git mv>,
        ~$current-file,
        ~$current-file.parent.child("minecraft-server-{$newest-fn}.ebuild");

    note "Would run: {@cmd.perl}";

    exit unless prompt('Update? [y/N] ') ~~ rx:i{^y[es]?};

    run(|@cmd) or die q{Couldn't git mv (dirty working copy?)};
    chdir(get-repo-dir());
    run(<repoman manifest>) or die q{repoman failed (FIX IT)};
    run(<git commit -a>);
}

sub get-repo-dir(--> IO::Path) {
    $*PROGRAM.parent.parent;
}

sub get-ebuild-dir(--> IO::Path) {
    get-repo-dir()
        .child('games-server')
        .child('minecraft-server')
        .cleanup(:parent);
}

sub get-current-ebuild(--> Pair) #`(version number => filehandle) {
    my Regex $test = rx/'minecraft-server-' ($snapshot-fn | $prerelease-fn) '.ebuild'$/;

    my $ebuild-dir = get-ebuild-dir();
    my $ebuild = $ebuild-dir.dir(:$test).cache;

    die qq[Expected one snapshot/prerelease ebuild but you have {$ebuild.elems}]
        if $ebuild.elems != 1;

    $_ => $ebuild[0]
        with $ebuild.match($test)[0];
}
