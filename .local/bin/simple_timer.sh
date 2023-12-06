#!/bin/sh

min="${1-}"
sec="${2-}"

if [ -z "${min}" ] || [ -z "${sec}" ] || [ -n "${3-}" ] ; then
	printf '%s\n' "Usage: ${0-} MIN SEC"
	exit 1
fi

print_as_minutes () {
	_total_sec="${1}"
	min="$((_total_sec / 60))"
	sec="$((_total_sec % 60))"
	clear -x
	n_lines="$(($(tput lines) / 2 - 4))"
	while [ "${n_lines}" -ge "0" ] ; do
		printf '\n'
		n_lines="$((n_lines - 1))"
	done
	figlet -w "$(tput cols)" -c "${min} : ${sec}"
}

total_sec="$((min * 60 + sec))"
while [ "${total_sec}" -ge "0" ] ; do
	print_as_minutes "${total_sec}"
	sleep 1s
	total_sec="$((total_sec - 1))"
done
