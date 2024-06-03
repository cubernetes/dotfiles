#!/bin/bash

set -euo pipefail
###################### STOP ###################
# Put device in pairing mode!!!

# MUST be uppercase
MX5_MAC="AC:80:0A:6D:F3:7B"
MX5_SINK="bluez_sink.AC_80_0A_6D_F3_7B.a2dp_sink"
MX3_MAC="14:3F:A6:A8:7F:CD"

DEVICE_MAC="${MX5_MAC}"
DEVICE_SINK="${MX5_SINK}"

function log () {
	printf "\n\033[31m%s\033[m\n" "${@}" >/dev/tty
}

bluetoothctl power on \
	&& bluetoothctl connect "${DEVICE_MAC}"

pactl set-default-sink "${DEVICE_SINK}" || true

bluetoothctl connect "${DEVICE_MAC}" ||
	{ sleep 3; bluetoothctl connect "${DEVICE_MAC}"; }

pactl set-default-sink "${DEVICE_SINK}"
