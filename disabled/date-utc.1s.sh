#!/bin/bash -eu
#
# Screenshot: https://cloud.githubusercontent.com/assets/627486/23837059/47565150-073f-11e7-9a92-00fce65e72fc.png

PATH="/opt/homebrew/bin:$PATH"

gdate --utc +%dT%H:%MZ
echo ---
gdate --utc +%FT%TZ
