use v6;
# XXX brace form is working around broken MAIN-inside-module
module Minecraft::VersionCheck:auth<github:flussence>:ver<1.0.0> {

#| Returns ([+year,+week,~letter] => ~jar-url) of newest snapshot on success.
#| May fail, as it uses heuristics relative to current datetime to guess URLs.
sub get-newest-snapshot() returns Pair is export {
    my $now = DateTime.now;
    my $year = $now.year - 2000;

    # Step backwards through weeks until we have something
    for $now.week-number X- ^5 -> $week {
        my Pair $found-version;

        # Step forward through revisions until we stop finding something
        for 'a'..'z' -> $letter {
            my $version = sprintf('%02dw%02d%s', $year, $week, $letter);

            # XXX working around lack of topicaliser
            with get-url-for-version($version) -> $url {
                $found-version = [$year, $week, $letter] => $url;
            }
            else {
                last;
            }
        }

        # XXX .return ought to work but the pair seems to flatten?
        return $_ with $found-version;
    }

    return Pair;
}

sub get-url-for-version(Str:D $ver) returns Str {
    my $host = 's3.amazonaws.com';
    my $url  = "/Minecraft.Download/versions/{$ver}/minecraft_server.{$ver}.jar";

    $*ERR.print: "Trying $ver... ";
    my $head = http-head($host, $url);

    if response-ok($head) {
        note 'Found.';
        return "http://{$host}{$url}";
    }
    else {
        note 'Not found.';
        return Str;
    }
}

sub http-head(Str:D $host, Str:D $url) returns Buf {
    my @headers =
        "HEAD $url HTTP/1.1",
        "Host: $host",
        "Connection: close",
        "",
    ;

    my $sock = IO::Socket::INET.new(:$host, :port(80));
    $sock.print: (@headers X~ "\r\n").join;

    my Buf $head = Buf.new;
    until $head.bytes >= q{HTTP/1.x 200}.chars {
        $head ~= $sock.recv(:bin);
    }

    $sock.close;

    return $head;
}

sub response-ok(Buf $response) returns Bool {
    return ascii-substr($response, q{HTTP/1.x }.chars, 3) eq '200';
}

sub ascii-substr(Buf $b, $from, $to) {
    return $b.subbuf($from, $to).decode('ascii');
}

} # end of module

sub MAIN() {
    import Minecraft::VersionCheck;
    say q{Finding latest snapshot...};

    with get-newest-snapshot() -> $_ {
        say "{.key} is the newest version ({.value})";
    }
    else {
        say q{Didn't find anything!};
    }
}
