#!/bin/sh
set -x
echo "inside stop_st60_demo"
killall watch gst-launch-1.0
#killall touch-event-gtk-player
