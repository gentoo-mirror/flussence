#!/bin/sh
curl -s http://s3.amazonaws.com/Minecraft.Download/versions/versions.json | \
    perl -ne 'print if /\Q"latest": {\E/ .. /\Q},\E/'
