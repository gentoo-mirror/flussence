#!/usr/bin/env perl6

sub MAIN {
    my Pair $current = get-current-version;
    say "{$current.key} is the current version ({$current.value})";

    my Pair $newest = get-newest-version;
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

sub get-current-version() returns Pair #`(version number bits => filehandle) {
    my Regex $ebuild-name = rx/'minecraft-server-' (\d\d)(\d\d)(\w) '.ebuild'$/;

    my $ebuild-dir = get-ebuild-dir();

    my $ebuild = $ebuild-dir.dir(test => $ebuild-name);

    die qq{You shouldn't have more than one $ebuild-name in here}
        if $ebuild.elems != 1;

    my $version = $ebuild.Str.match($ebuild-name).list.item;

    return $version => $ebuild[0];
}

sub get-newest-version() returns Pair {
    my $now = DateTime.now;
    my $year = $now.year - 2000;
    my $newest-version;

    for $now.week-number X- ^5 -> $week {
        for 'a'..'z' -> $letter {
            my $version = sprintf('%02dw%02d%s', $year, $week, $letter);

            if get-url-for-version($version) -> $url {
                $newest-version = [$year, $week, $letter] => $url;
            }
            else {
                last;
            }
        }

        last if $newest-version;
    }

    return $newest-version;
}

sub get-url-for-version(Str $version) {
    my $host = 's3.amazonaws.com';
    my $url  = "/Minecraft.Download/versions/{$version}/minecraft_server.{$version}.jar";

    my $head = HEAD($host, $url);

    if response-ok($head) {
        note "$version is available.";
        return "http://{$host}{$url}";
    }
    else {
        note "Didn't receive a good reply";
        return False;
    }
}

sub HEAD(Str $host, Str $url) returns Buf {
    my @headers =
        "HEAD $url HTTP/1.1",
        "Host: $host",
        "Connection: close",
        "",
    ;

    note "Trying @headers[0]";
    my $sock = IO::Socket::INET.new(:$host, :port(80));
    $sock.print($_ ~ "\r\n") for @headers;

    my Buf $head = Buf.new;
    until $head.bytes >= 'HTTP/1.1 200'.chars {
        $head ~= $sock.recv(:bin);
    }

    $sock.close;

    return $head;
}

sub response-ok(Buf $response) returns Bool {
    return ascii-substr($response, 9, 3) eq '200';
}

sub ascii-substr(Buf $b, $from, $to) {
    return $b.subbuf($from, $to).decode('ascii');
}
