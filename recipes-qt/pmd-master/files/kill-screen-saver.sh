#!/bin/sh

# (not sure if this is strictly necessary)
export DISPLAY=:0
echo `date` >/j.log
echo "$0" >>/j.log

xset s off
xset -dpms
xset s noblank
