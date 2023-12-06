#!/bin/sh

bluetoothctl power on \
	&& bluetoothctl connect 14:3F:A6:A8:7F:CD

sleep 3

bluetoothctl connect 14:3F:A6:A8:7F:CD ||
	{ sleep 3; bluetoothctl connect 14:3F:A6:A8:7F:CD; }
