#!/usr/bin/bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar
# or
# ps -ef | grep polybar | grep -v grep | grep -v launch | awk '{print $2}'| xargs kill -9

# Launch polybar
# Launch bar and left bar, right bar
echo "---" | tee -a /tmp/bar.log /tmp/left-bar.log /tmp/right-bar.log
polybar bar 2>&1 | tee -a /tmp/bar.log &
disown
polybar left 2>&1 | tee -a /tmp/left-bar.log &
disown
polybar right 2>&1 | tee -a /tmp/right-bar.log &
disown

echo "Bars launched..."
