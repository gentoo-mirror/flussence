#!/bin/sh
curl -s https://launchermeta.mojang.com/mc/launcher.json | \
json_pp | \
perl -ne 'print if /\Q"java"\E/ .. /^\s{3}\Q},\E/'
