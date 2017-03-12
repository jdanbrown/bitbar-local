#!/bin/bash -eu

PATH="/usr/local/bin:$PATH"

gdate --utc +%H:%MZ
echo ---
gdate --utc +%FT%TZ
