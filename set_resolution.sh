#!/bin/bash

EXPECTED=$1
REFRESH="${2:-60}" # 默认刷新率为60Hz

if [[ "$EXPECTED" =~ ^[0-9]+x[0-9]+$ ]]; then
	echo "Expected resolution: $EXPECTED $REFRESH"
else
	echo "Args error"
	exit 1
fi

DISPLAY_NAME=$(xrandr | grep -E "\sconnected" | awk '{print $1}')
if [ -z "$DISPLAY_NAME" ]; then
	echo "Did not find DISPLAY_NAME"
	exit 1
fi

if ! xrandr | grep "$EXPECTED"; then
	echo "Resolution mode ${MODE_NAME} not exsit, create it at fisrt"
	IFS='x' read -r width height <<< "$EXPECTED"
	echo "Expected width: $width"
	echo "Expected height: $height"

	MODELINE=$(cvt "$width" "$height" "$REFRESH" 2> /dev/null | grep -i "modeline" | awk '{$1=""; $2=""; print substr($0,2)}')
	if [ -z "$MODELINE" ]; then
		echo "could not create modeline"
		exit 1
	fi

	xrandr --newmode "$EXPECTED" $MODELINE
	xrandr --addmode "$DISPLAY_NAME" "$EXPECTED"
fi

echo "set to $EXPECTED $REFRESH"
xrandr --output "$DISPLAY_NAME" --mode "$EXPECTED"
