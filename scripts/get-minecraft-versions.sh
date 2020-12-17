#!/bin/sh
curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | \
json_pp | \
perl -ne 'print if /\Q"latest"\E/ .. /\Q},\E/'
