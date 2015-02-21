#!/usr/bin/env perl6

sub MAIN {
    my Pair $current = get-current-version;
    say "{$current.key} is the current version ({$current.value})";

    my Pair $newest = get-newest-version;
    say "{$newest.key} is the newest version ({$newest.value})";

    exit unless $newest.key ge $current.key
            and prompt('Update? [Y/n] ') !~~ /^[Nn]/;

    given $current.value {
        shell("git mv {$_.Str} {.parent.child("minecraft-server-{$newest.key.join}.ebuild")}");
    }

    shell('cave digest minecraft-server flussence');
    shell('git commit -a');
}

sub get-current-version() returns Pair {
    my Regex $ebuild-name = rx/'minecraft-server-' (\d\d)(\d\d)(\w) '.ebuild'$/;

    # This is _horrible_.
    my $ebuild-dir = $*PROGRAM_NAME.IO.parent.parent;
    $ebuild-dir.=child($_) for <games-server minecraft-server>;
    $ebuild-dir.=cleanup(:parent);

    my $ebuild = $ebuild-dir.dir(test => $ebuild-name);
    # You shouldn't have more than one snapshot ebuild in here
    die if $ebuild.elems != 1;

    my $version = $ebuild.Str.match($ebuild-name).list.item;

    return $version => $ebuild[0];
}

sub get-newest-version() returns Pair {
    my $now = DateTime.now;
    my $year = $now.year - 2000;
    my $newest-version;

    for $now.week-number.pred X- ^5 -> $week {
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
    $sock.send($_ ~ "\r\n") for @headers;

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
