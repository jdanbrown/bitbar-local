#!/bin/bash -eu
#
# Inspired by https://github.com/matryer/bitbar-plugins/blob/master/Network/ping.10s.sh
# Screenshot: https://cloud.githubusercontent.com/assets/627486/23837056/376cdf7a-073f-11e7-950f-a8ef26fbdae9.png

# Docs:
# - https://xbarapp.com/docs/
# - https://github.com/matryer/xbar-plugins/blob/main/CONTRIBUTING.md

PATH="/opt/homebrew/bin:$PATH"

#home_wifi_gateway='192.168.0.1'
#od_wifi_gateway='10.116.0.1'
current_gateway="`route -n get default | gsed -nE '/gateway:/ s/.*: (.*)/\1/ p'`"

icon_hosts=(
  "📶 $current_gateway" # wifi
  # '🔒 192.168.255.1' # vpn
  '🌍 1.1.1.1' # internet
  '🌍 8.8.4.4' # internet
)

timeout_s=1
history_lines=50
line_format='disabled=true size=12 font=Consolas trim=false'
log_file='/tmp/xbar-ping.log'

timeouts=''
printf '%-11s' "[`date +%H:%M:%S`]" >>"$log_file"
for icon_host in "${icon_hosts[@]}"; do
  read icon host <<< "$icon_host"
  ping_ms="$(ping -c1 -t"$timeout_s" -n -q "$host" 2>/dev/null | awk -F/ 'END {printf "%.1f\n", $5}')"
  if [ "$ping_ms" = '0.0' ]; then
    line="          (>${timeout_s}s)"
    timeouts+="$icon"
  else
    line="$ping_ms ms"
  fi
  printf '%18s' "$line" >>"$log_file"
done
echo >>"$log_file"
if [ -z "$timeouts" ]; then
  msg="⚪"
else
  msg="[$timeouts]"
fi

if [ $(($RANDOM % 10)) -eq 0 ]; then
  tail -"$history_lines" "$log_file" >"$log_file.tmp"
  mv "$log_file.tmp" "$log_file"
fi

echo "$msg"
echo ---
echo 'Bounce wifi | terminal=false bash=/bin/bash param1=-c param2="networksetup -setairportpower en0 off && networksetup -setairportpower en0 on"'
echo ---
printf '%-11s' ''
for icon_host in "${icon_hosts[@]}"; do
  read icon host <<< "$icon_host"
  printf '%18s' "[$host]"
done
echo " | $line_format"
tail -"$history_lines" "$log_file" | gtac | gsed "s/\$/ | $line_format/"
