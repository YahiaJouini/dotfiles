#!/usr/bin/env bash

# find wlsunset process
PID=$(pgrep -x wlsunset)

if [ -z "$PID" ]; then
    # not running, start it
    source ~/.local_env
    wlsunset -l "$WLSUNSET_LAT" -L "$WLSUNSET_LON" -t "$WLSUNSET_NIGHT_TEMP" -T "$WLSUNSET_DAY_TEMP" &
else
    # toggle pause/resume
    kill -USR1 "$PID"
fi

