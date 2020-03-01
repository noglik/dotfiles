#!/usr/bin/bash
awk '{
brightness_value=$1-50;
if (brightness_value < 200)
	print "200";
else
	print brightness_value;
}' /sys/class/backlight/intel_backlight/brightness > /sys/class/backlight/intel_backlight/brightness
