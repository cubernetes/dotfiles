#! /bin/sh -

###################### STOP ###################
# Put device in pairing mode!!!

# hex MUST be uppercase
MX5_MAC="AC:80:0A:6D:F3:7B"
MX3_MAC="14:3F:A6:A8:7F:CD"

DEVICE_MAC="$MX5_MAC"

log () {
	printf "\n\033[31m%s\033[m\n" "$*" >/dev/tty
}

log "rfkill block bluetooth..."
rfkill block bluetooth
log "sudo rmmod btusb..."
sudo rmmod btusb
log "sudo modprobe btusb..."
sudo modprobe btusb
log "rfkill unblock bluetooth..."
rfkill unblock bluetooth
log "sudo systemctl restart bluetooth..."
sudo systemctl restart bluetooth
# echo "btmgmt"
# btmgmt

log "Waiting 3 seconds..."
sleep 3
(

log "Powering on bluetooth agent..."
cat <<- CMDS
	power on
	agent on
	default-agent
	pairable on
	discoverable on
CMDS

log "Removing ${DEVICE_MAC}..."
echo "remove ${DEVICE_MAC}"
log "Turning on scanning..."
echo "scan on"

log "Waiting until ${DEVICE_MAC} is found..."
while : ; do
	sleep 1
	bluetoothctl devices | grep -q "${DEVICE_MAC}" && break
done
log "Found ${DEVICE_MAC}."
log "Turning off scanning..."
echo "scan off"

log "Pairing with ${DEVICE_MAC}..."
echo "trust ${DEVICE_MAC}"
echo "pair ${DEVICE_MAC}"

log "Waiting 3 seconds"
sleep 3

log "Connecting to ${DEVICE_MAC}..."
echo "connect ${DEVICE_MAC}"
log "Waiting until connected"
while : ; do
	connected="0"
	for mac in $(bluetoothctl devices | awk '{print $2}'); do
		[ ! "${mac}" = "${DEVICE_MAC}" ] && continue
		bluetoothctl info "${mac}" | grep -q "Connected: yes" && { connected="1"; break; }
	done
	[ "${connected}" = "1" ] && break
	log "Not yet connected with ${DEVICE_MAC}."
	sleep 1
done
log "Connected with ${DEVICE_MAC}."
log "Trying one more time..."
echo "connect ${DEVICE_MAC}"
log "Done."
) | bluetoothctl
