#! /bin/bash --

choose_from_menu () {
    local prompt="${1}"
	local outvar="${2}"
    shift
    shift
    local options=("$@")
	local cur=0
	local count=${#options[@]}
	local index=0
    printf '\033[31m%s\033[m\n' "${prompt}"
    while true ; do
        # list all options (option list is zero-based)
        index='0'
        for o in "${options[@]}" ; do
            if [ "${index}" = "${cur}" ] ; then
				printf ' > \033[30;42m%s\033[m\n' "${o}"
            else
				printf '   %s\n' "${o}"
            fi
            index="$(( index + 1 ))"
        done
		# shellcheck disable=SC2162
        read -sn1 key
        if   [ "${key}" = "k" ] ; then
			cur="$(( (count + cur - 1) % count ))"
        elif [ "${key}" = "j" ] ; then
			cur="$(( (count + cur + 1) % count ))"
        elif [ "${key}" = "" ]  ; then
			printf '\033[%sA\033[J' "${count}"
			printf '\033[30;42m%s\033[m\n' "brave ${options["${cur}"]}"
			break
        fi
        printf '\033[%sA' "${count}"
    done
    printf -v "${outvar}" '%s' "${options["${cur}"]}"
}

choose_from_menu "Open URL with brave:" choice "${@}"

if [ -n "${choice}" ] ; then
	DISPLAY=:0 nohup brave "${choice}" 2>/dev/null 1>&2 & disown
fi
