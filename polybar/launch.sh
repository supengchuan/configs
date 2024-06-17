#!/usr/bin/bash

# Terminate already running bar instances
# pkill -9 polybar
ps -ef | grep polybar | grep -v grep | grep -v launch | awk '{print $2}'| xargs kill -9

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar bar -c ~/.config/polybar/config.ini >/dev/null 2>&1 &
sleep 1s
polybar left -c ~/.config/polybar/config.ini >/dev/null 2>&1 &
#sleep 1s
polybar right -c ~/.config/polybar/config.ini >/dev/null 2>&1 &


