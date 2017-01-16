#!/bin/sh
json-glib-format --prettify \
    <(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json) \
    | perl -ne 'print if /\Q"latest"\E/ .. /\Q},\E/'
