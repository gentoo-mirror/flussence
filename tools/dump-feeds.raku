#!/usr/bin/env raku
# vim: ft=perl6 tw=98

#| This program pulls out the changelog URLs in package metadata.xml and spits out an OPML file.
#| In this repository it's assumed <changelog>s all point to a valid feed file. That's not
#| mandated by the metadata.xml spec, but I have higher standards.
sub MAIN(IO::Path() $repo-root where *.d = $*PROGRAM.parent.parent);

my $cat-dir = { .IO.d and .contains('-') };
my $pkg-dir = none(<. .. metadata.xml>);

# OPML is a shit mid-2000s XML format, underspecced, no validators, useless wikipedia page.
# Everything that *implements* it gets it wrong too. Liferea dumps this into a flat list.
# Someone needs to make something better than this.
print q:c:to{EOT};
    <opml version="2.0">
      <head>
        <title>Overlay package changelogs</title>
        <dateCreated>{DateTime.now}</dateCreated>
        <docs>http://dev.opml.org/spec2.html</docs>
      </head>
      <body>
        <outline type="folder" text="{$repo-root.child('profiles/repo_name').lines} repository">
    EOT

for $repo-root.dir(test => $cat-dir) -> $cat {
    my Bool $has-contents = False; #= Don't create empty folders

    for $cat.map(*.dir(test => $pkg-dir)).flat -> $pkg {
        with $pkg.child('metadata.xml').slurp ~~ /'<changelog>' <(.*?)> '</changelog>'/ -> $uri {
            put qq{<outline type="folder" text="$cat">}.indent(6) unless $has-contents;
            $has-contents = True;
            put qq{<outline type="rss" text="$pkg.basename()" xmlUrl="$uri"/>}.indent(8);
        }
    }

    put qq{</outline>}.indent(6) if $has-contents;
}

print q:to{EOT};
        </outline>
      </body>
    </opml>
    EOT
