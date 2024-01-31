#! /usr/bin/bash -
# This file ought to be sourced, above line for syntax highlighting purposes.

######################## BASH RESET #############################
IFS=" 
	"
POSIXLY_CORRECT='1'
COMMANDS_="builtin unalias unset read printf command exit type . tr fc compgen"
COMMANDS_="${COMMANDS_-} wc sed grep xargs sudo shopt kill ps head awk clear"
COMMANDS_="${COMMANDS_-} curl wget source check mv mkdir rm rmdir while do done"
COMMANDS_="${COMMANDS_-} cc gcc g++ clang basename clone42 git alias export pwd"
COMMANDS_="${COMMANDS_-} docker shift until for in bash sh dash ash ksh zsh top"
COMMANDS_="${COMMANDS_-} shellcheck watch cmatrix alacritty tmux zellij ssh"
COMMANDS_="${COMMANDS_-} which date df du case esac crontab ping base64 apt"
COMMANDS_="${COMMANDS_-} paru pacman yum dnf aptitude apt-get yay rpm dpkg env"
COMMANDS_="${COMMANDS_-} awk apropos help info dirname bc dc break continue"
COMMANDS_="${COMMANDS_-} unzip zip tar untar gzip gunzip xz unxz base32 cal"
COMMANDS_="${COMMANDS_-} chattr cfdisk fdisk passwd chroot cmp cron split dd"
COMMANDS_="${COMMANDS_-} df dir declare diff dircolors dmesg eval exec egrep"
COMMANDS_="${COMMANDS_-} false true : fg bg free fold find file gawk groupadd"
COMMANDS_="${COMMANDS_-} less more cat head tail chmod chown history sleep yes"
COMMANDS_="${COMMANDS_-} useradd adduser addgroup usermod groupdel userdel xxd"
COMMANDS_="${COMMANDS_-} groups users who w last hash hostname htop ip ifconfig"
COMMANDS_="${COMMANDS_-} install ifdown ifup jobs killall pkill pgrep klist"
COMMANDS_="${COMMANDS_-} link ln unlink let local logout logname lsblk lsof"
COMMANDS_="${COMMANDS_-} pidof lspci lsusb lscpu make mktemp mount umount nc"
COMMANDS_="${COMMANDS_-} ncat nmap nft iptables ufw firewall-cmd nl nslookup"
COMMANDS_="${COMMANDS_-} open xdg-open whereis whatis write wall agetty amixer"
COMMANDS_="${COMMANDS_-} pulsemixer ar cmake bzip2 ccrypt chvt column chsh ex"
COMMANDS_="${COMMANDS_-} od pushd popd pv pvs lvs vgs rsync screen sed seq wait"
COMMANDS_="${COMMANDS_-} ftp sftp shift shuf sort uniq su strace sync tee test"
COMMANDS_="${COMMANDS_-} time trap tr tty ulimit umask unix2dos dos2unix uptime"
COMMANDS_="${COMMANDS_-} paco francinette cd ls disown whoami reboot systemctl"
COMMANDS_="${COMMANDS_-} shutdown poweroff set x touch stat cp scp man locate"
COMMANDS_="${COMMANDS_-} xset kbdrate return cut batcat id ed vi vim nvim nano"
COMMANDS_="${COMMANDS_-} skill norminette bat echo if then fi else function"
COMMANDS_="${COMMANDS_-} PROMPT_COMMAND PS0 PS1 PS2 PS3 PS4"
# shellcheck disable=SC2086
2>/dev/null \unset -f -- ${COMMANDS_-} || true
# shellcheck disable=SC2086
2>/dev/null \unalias -- ${COMMANDS_-} || true
\builtin -- hash -r
2>/dev/null \unset -- POSIXLY_CORRECT COMMANDS_
######################## BASH RESET END #############################

[ -z "${PS1-}" ] && return
set -o emacs
tabs -4
shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -u histverify
shopt -s autocd
HISTSIZE='-1'
HISTFILESIZE='-1'
HISTFILE="${HOME}"/.bash_history
HISTTIMEFORMAT=$'\033[m%F %T: '
HISTCONTROL='ignoreboth:erasedups'
# PROMPT_COMMAND="history -n; history -w; history -c; history -r"
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if 2>/dev/null 1>&2 command -v nvim; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
elif 2>/dev/null 1>&2 command -v vim; then
    alias v='vim'
    alias vi='vim'
elif 2>/dev/null 1>&2 command -v nvi; then
    alias v='nvi'
    alias vi='nvi'
elif 2>/dev/null 1>&2 command -v vi; then
    alias v='vi'
fi

alias gdb='gdb -q'
alias objdump='objdump --disassembler-color=extended-color -Mintel'
alias v='nvim'
alias vim='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias sudo='sudo '
alias s='echo sudo $(fc -nl -2 | head -1 | cut -c3-); eval sudo $(fc -nl -2 | head -1 | cut -c3-)' # cut -c2- for bash posix mode
alias watch='watch '
alias tmux='tmux -2'
alias open='xdg-open'
alias xcopy='xsel --clipboard --input'
alias xpaste='xsel --clipboard --output'
alias aptclean='sudo apt -y update && sudo apt -y full-upgrade &&
                sudo apt -y dist-upgrade && sudo apt -y autoremove &&
                sudo apt -y clean'
# shellcheck disable=SC2032
alias pacman='pacman --color=auto'
alias pcker='nvim "${HOME-}"/.config/nvim/lua/*'
alias after='nvim "${HOME-}"/.config/nvim/after/plugin'
alias l='\ls --width="${COLUMNS:-80}" --sort=time --time=mtime --color=auto --time-style=long-iso -bharZ1l'
# alias l='lsd --timesort --color=auto -harZ1l'
alias ll='\ls --width="${COLUMNS:-80}" --sort=time --time=mtime --color=auto --fu -bharZ1l'
alias ls='\ls --width="${COLUMNS:-80}" --color=auto -bC'
alias ip='ip -color=auto'
alias ipa='ip -br -color=auto a'
alias grep='grep --color=auto'
alias diff='diff --width="${COLUMNS:-80}" --color=auto'
alias less='less -SR'
alias dmesg='dmesg --color=auto --reltime --human --nopager --decode'
alias free='free -mht'
alias tree='tree --dirsfirst -C'
alias francinette='"${HOME-}"/francinette/tester.sh'
alias paco='"${HOME-}"/francinette/tester.sh'
alias wttr='curl wttr.in'
alias colors='bash -c "$(curl --silent --location \
"https://gist.githubusercontent.com/HaleTom/\
89ffe32783f89f403bba96bd7bcd1263/raw"
)"'
alias sl='sl -GwFdcal'
alias cmatrix='cmatrix -u3 -Cred'
alias gca='git add -u && git commit -m "Automatic add"'
alias watch='watch -tcn.1'
alias pacop='clear && 2>/dev/null paco && 2>/dev/null paco --strict'
alias xterm='xterm -bg black -fg white'
alias norm='alacritty -e sh -c '\''watch -cn.5 \
            norminette -R CheckForbiddenSourceHeader'\'' & disown'
alias norm2='alacritty -e sh -c '\''watch -cn.5 \
            norminette -R CheckForbiddenSourceHeader \| \
            xargs -I{} printf \"{} \#\#\# \"'\'' & disown'
alias dotconf='git --git-dir="${HOME-}"/.dotfiles/ --work-tree="${HOME-}"'
alias r='ranger'
2>/dev/null dotconf config status.showUntrackedFiles no

# auto_pushd
function cd () {
	command cd "${@}" || return 1
	pwd="${PWD}"
	1>/dev/null command cd - || return 1
	1>/dev/null pushd "${pwd}" || return 1
}

CDPATH="${CDPATH}:${HOME}"
CDPATH="${CDPATH}:${HOME}/projects"
CDPATH="${CDPATH}:${HOME}/projects/aoc"
CDPATH="${CDPATH}:${HOME}/projects/aoc/2023"
CDPATH="${CDPATH}:${HOME}/42ecole"
CDPATH="${CDPATH}:${HOME}/42ecole/42cursus"

function paruuu () {
	read -p 'Do system upgrade (Y) or exit (n)' choice
	if [ ! "${choice}" = "y" -a ! "${choice}" = "Y" -a -n "${choice}" ]; then
		exit
	fi
	ssid="$(iw dev wlan0 link |
			grep SSID |
			sed -e 's/[[:blank:]]*SSID: //' \
				-e 's/[[:blank:]]*$//'
	)"
	if : \
		&& [ ! "${ssid-}" = "Free Wifi" ] \
		&& [ ! "${ssid-}" = "FreeWifi" ] \
		&& [ ! "${ssid-}" = "DS_JD-Tree" ] \
		&& [ ! "${ssid-}" = "Haihin" ] \
		&& [ ! "${ssid-}" = "∞" ] \
		&& [ ! "${ssid-}" = "\xe2\x88\x9e" ] \
		&& [ ! "${ssid-}" = $'\xe2\x88\x9e' ] \
		&& [ ! "${ssid-}" = "Nichts 5" ] \
		&& [ ! "${ssid-}" = "Nichts 2,4" ] \
		&& [ ! "${ssid-}" = "Pink Flamingo" ] \
		&& [ ! "${ssid-}" = "Pink Flamingo_5G" ] \
		&& [ ! "${ssid-}" = "42Berlin_Student" ] \
		&& [ ! "${ssid-}" = "42Berlin_Guest" ] \
		&& [ ! "${ssid-}" = "ZorgatiHome Guest" ] \
		&& [ ! "${ssid-}" = "Rudolph" ] \
		&& [ ! "${ssid-}" = "Hackme" ] \
		&& [ ! "${ssid-}" = "hackme3" ] \
		&& [ ! "${ssid-}" = "Silmaril 4 (5)" ] \
		&& [ ! "${ssid-}" = "Silmaril 4 (2.4)" ] \
		&& [ -n "${ssid-}" ] \
	&& : ; then
		read -p "[31mYou're connected to '${ssid-}', update anyway (Y|n)?[m" choice
		if [ ! "${choice}" = "y" -a ! "${choice}" = "Y" -a -n "${choice}" ]; then
			exit
		fi
	fi
	# shellcheck disable=SC2033
	time (
		printf '\033[30;41m%s\033[m\n' 'Cache credentials for sudo:' \
			&& sudo -v \
			&& printf '\033[30;41m%s\033[m\n' 'Updating mirrorlist' \
			&& curl -sSL "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" \
				| sed -e 's/^#Server/Server/' -e '/^#/d' \
				| rankmirrors -n 8 - \
				| sudo tee /etc/pacman.d/mirrorlist \
			&& clear \
			&& printf '\033[30;41m%s\033[m\n' 'pacman -Sy archlinux-keyring' \
			&& yes | sudo pacman -Sy archlinux-keyring \
			&& printf '\033[30;41m%s\033[m\n' 'pacman -Syyuu --noconfirm' \
			&& yes | sudo pacman -Syyuu --noconfirm \
			&& printf '\033[30;41m%s\033[m\n' 'paru -Syyu --devel --noconfirm' \
			&& yes | paru -Syyu --devel --noconfirm \
			&& printf '\033[30;41m%s\033[m\n' 'pacman -Qtdq | pacman -Rns -' \
			&& { pacman -Qtdq | 2>/dev/null sudo pacman --noconfirm -Rns - \
			|| printf '\033[30;42m%s\033[m\n' 'No pacman orphan packages :)!'; } \
			&& yes | paru -Scc -d \
		&& printf '\n\033[30;42m%s\033[m\n' '###### Done without error ######' \
		|| printf '\n\033[30;41m%s\033[m\n' '###### Some error occured! ######'
	)
}

function skill () {
	if [ -n "${1-}" ] ; then
		# shellcheck disable=SC2046,SC2009
		2>/dev/null kill -9 \
			-- $(ps auxww | grep "${1-}" | grep -v grep | awk '{print $2}') \
			&& return 0
		2>/dev/null sudo kill -9 \
			-- $(ps auxww | grep "${1-}" | grep -v grep | awk '{print $2}')
	else
		echo 'Please provide one argument'
	fi
}

function wpa_restart () {
	skill wpa_supplicant
	sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
}

function bat () {
	2>/dev/null command -v batcat && { batcat "${@}"; return 0; }
	2>/dev/null command -v bat && { $(type -P bat) "${@}"; return 0; }
	{ printf '%s\n' "bat not found"; return 1; }
}

function take () {
    mkdir -p -- "$1" &&
       cd -P -- "$1" ||
		return 1;
}

function norminette () {
	local vers
	local newst

	vers="$($(type -P norminette) -v | cut -d" " -f2)"
	newst='3.3.55'
	if [ ! "${vers-}" = "${newst-}" ] ; then
		printf "%s\n%b\n" "Norminette v${vers-} instead of v${newst-} detected."\
                          '\033[31mPlease up-/downgrade\033[m'
	fi
	$(type -P norminette) -R CheckForbiddenSourceHeader "${@}"
}

function __norm () {
	local _pwd

	return 0
	_pwd="$(pwd -P)"
	[ -n "${_pwd-}" ] && [ -z "${_pwd##${HOME-}/42/42cursus/*}" ] || { return 1; }
	1>/dev/null 2>&1 git status || { return 2; }
    1>/dev/null 2>&1 norminette && printf ' \033[92m%s\033[m' "[Norm: OK]" || printf ' \033[101;37m%s\033[m' "[䝝誒 ‼ NORM ‼ 屌誒]"
    return 0
}

function ft_check () {
    # Set params
    URL="${1}"
    DIR="/tmp/tmp_repo_$(date +%s)"

    # If no URL, get it from current repo
    if [ -z "${URL-}" ] ; then
        URL="$(git remote get-url origin)"
    fi

    # Clone in temp folder
    git clone --quiet "${URL}" "${DIR}"

    # Only proceed if clone success
    if [ -d "${DIR}" ] ; then
        # Check the norm and print beautiful message
        norminette -R CheckForbiddenSourceHeader "${DIR}" && printf '\033[30;102m%s\033[m\n' "Norminette success" || printf '\033[30;101m%s\033[m\n' "Norminette fail!!!"

            # Remove temp folder
            rm -rf -- "${DIR}"
        else
            printf '\033[30;101m%s\033[m\n' "Could not clone the repo"
    fi
}

function clone42 () {
    folder="${1}"
    repo_url="${2}"

	# shellcheck disable=SC2015
    git clone --quiet "${repo_url}" "${folder}" && {
        cd "${folder}";
		norminette -R CheckForbiddenSourceHeader ".";
	} || { printf '%s\n' "Could not clone repo!"; }
}

# shellcheck disable=SC2016
export GIT_SSH_COMMAND='ssh -oIdentitiesOnly=yes -F"${HOME-}"/.ssh/config'
if [ ! "${TERM-}" = "linux" ] ; then
	if [ -f '/usr/share/terminfo/x/xterm-256color' ] ; then
		export TERM='xterm-256color'
	elif [ -f '/usr/share/terminfo/x/xterm-color' ] ; then
		export TERM='xterm-color'
	elif [ -f '/usr/share/terminfo/x/xterm' ] ; then
		export TERM='xterm'
	elif [ -f '/usr/share/terminfo/s/screen-256color' ] ; then
		export TERM='screen-256color'
	elif [ -f '/usr/share/terminfo/s/screen' ] ; then
		export TERM='screen'
	fi
fi
# # shellcheck disable=SC2155
# export VISUAL="$(2>/dev/null $(type -P nvim))"
export VISUAL="vi"
# # shellcheck disable=SC2155
export EDITOR="vi"
# export EDITOR="$(2>/dev/null $(type -P vim)  ||
#                  2>/dev/null $(type -P vi)   ||
#                  2>/dev/null $(type -P nano) ||
#                  2>/dev/null $(type -P ed))"
export SUDO_EDITOR="${EDITOR-}"
export GIT_PS1_SHOWDIRTYSTATE='1'
export MANPAGER='nvim +Man!'
[ -z "${DISPLAY-}" ] && echo 'Warning: DISPLAY is not set'


###################### PROMPT STUFF #######################
# If bash runs in posix mode, if should be `cut -c2-' instead
# shellcheck disable=SC2016
PS0='$(clear -x ; printf "${PS1@P}" ; fc -nl -1 | cut -c3- ; printf "\n")'

if [ ! -f "${HOME}"/.bash-preexec.sh ] ; then
	curl --silent --location \
"https://raw.githubusercontent.com/rcaloras\
/bash-preexec/master/bash-preexec.sh" \
	-o "${HOME}"/.bash-preexec.sh
fi

# shellcheck disable=SC1091
. "${HOME}"/.bash-preexec.sh

preexec() {
	TIMESTAMP_BEFORE="$(date +%s)"
}
precmd() {
	local sec_diff
	local TIMESTAMP_NOW

	TIMESTAMP_NOW="$(date +%s)"
	sec_diff="$(( TIMESTAMP_NOW - TIMESTAMP_BEFORE ))"
	if [ -n "${TIMESTAMP_BEFORE-}" ] && [ "${sec_diff-}" -ge "5" ] ; then
		TOOK_STRING=' took '
		mins="$((sec_diff / 60))"
		secs="$((sec_diff % 60))"
		if [ "${mins-}" = "0" ] ; then
			TOOK_STRING="${TOOK_STRING-}${secs-}s"
		else
			TOOK_STRING="${TOOK_STRING-}${mins-}m${secs-}s"
		fi
	else
		unset -v -- TOOK_STRING
	fi
}

GIT_PROMPT="1"
if [ ! -f "${HOME}"/git-prompt.sh ] && [ "${GIT_PROMPT-}" = "1" ] ; then
	curl --silent --location \
"https://raw.githubusercontent.com/git\
/git/master/contrib/completion/git-prompt.sh" \
	-o "${HOME}"/git-prompt.sh
fi

_PS1_CWD_CLR='\[\033[33m\]'
_PS1_USER='\[\033[31m\]\u\[\033[m\]'
_PS1_SSH="$(
	set | grep -sq ^SSH_CONNECTION && printf "@\[\033[36m\]%s\[\033[m\]" "ssh"
)"
_PS1_TMUX="$(
	set | grep -sq ^TMUX_PANE && printf "@\[\033[35m\]%s\[\033[m\]" "tmux"
)"
[ -n "${_PS1_SSH-}" ] && _PS1_HOST_CLR='\[\033[30;42m\]' || \
                        _PS1_HOST_CLR='\[\033[32m\]'
_PS1_1="${_PS1_USER-}"
_PS1_1="${_PS1_1-}@${_PS1_HOST_CLR-}"
_PS1_1="${_PS1_1-}\h\[\033[m\]"
_PS1_1="${_PS1_1-}${_PS1_SSH-}${_PS1_TMUX-} "
_PS1_1="${_PS1_1-}${_PS1_CWD_CLR-}"
_PS1_1="${_PS1_1-}[\w]\${TOOK_STRING-}"
# shellcheck disable=SC2016
_PS1_GIT='\[\033[m\]\[\033[36m\]$(__git_ps1 " (%s)")'
# shellcheck disable=SC2016
_PS1_2='\[\033[m\]\[\033[36m\]$(__norm)\[\033[m\]\n\[\033[35m\]~\$\[\033[m\] '

if [ -f "${HOME}"/git-prompt.sh ] && [ -r "${HOME}"/git-prompt.sh ] && \
                                     [ "${GIT_PROMPT-}" = "1" ] ; then
	# shellcheck disable=SC1091
    . "${HOME}"/git-prompt.sh
    PS1="${_PS1_1-}${_PS1_GIT-}${_PS1_2-}"
else
    PS1="${_PS1_1-}${_PS1_2-}"
fi
######################### PROMPT STUFF END #######################

# Key Repeat/Delay Rate
2>/dev/null xset r rate 200 60
# Disable bell
2>/dev/null xset -b
# sudo kbdrate --rate=30.0 --delay=250

complete -C pomo pomo
eval "$(keyring --print-completion bash)"

# shellcheck disable=SC1091
if [ -f "${HOME}"/.userbashrc ]; then . "${HOME}"/.userbashrc; fi

# Simplified *Bash* Prompt, e.g. for tty/system/linux console
# unset PS0; PS1='\033[94m\u\033[37m@\033[32m\h\033[37m@\033[33m$(basename -- "$(tty)") \033[36m\w \033[35m\$\033[m '

push_swap_perf () {
	url="${1}"
	perf_dir="${2}"
	[ -z "${url}" ] && { echo "Expected two parameters (url && perf_dir)" ; return ; }
	[ -z "${perf_dir}" ] && { echo "Expected two parameters (url && perf_dir)" ; return ; }
	rm -rf -- "${perf_dir}" || { echo "Couldn't return" ; return ; }
	git clone --quiet --depth 1 "${url}" "${perf_dir}" || { echo "Couldn't clone" ; return ; }
	[ -f "./stack_a.txt" ] || { echo "File ./stack_a.txt does not exist!" ; return ; }
	stack_a_file="$(readlink -f -- "./stack_a.txt")"
	2>/dev/null 1>/dev/null pushd -- "${perf_dir}" || { echo "Couldn't cd into '${perf_dir}'" ; return ; }
	makefile_dir="$(find . -name Makefile | awk '{printf "%s|%s\n", $0, length($0)}' | sort -t'|' -k2,2g | head -1 | awk -F'|' '{print $1}' | xargs -r dirname)"
	[ -z "${makefile_dir}" ] && { echo "No Makefile found" ; return ; }
	2>/dev/null 1>/dev/null pushd -- "${makefile_dir}" || { echo "Couldn't cd into '${makefile_dir}'" ; return ; }
	find . -type f -exec sed -i -e 's/-Werror//g' {} \;
	find . -type f -exec sed -i -e 's/rewind/rewindx/g' {} \;
	2>/dev/null 1>/dev/null make -j$(nproc) -i -k -s || { echo "Couldn't run make" ; return ; }
	ops="$(2>/dev/null ./push_swap $(cat -- "${stack_a_file}") | wc -l)"
	echo "ops;${ops}"
	2>/dev/null 1>/dev/null popd
	2>/dev/null 1>/dev/null popd
}

# Add these to your ~/.bash_aliases

AOC_DIR="${HOME}/projects/aoc" # remember to change this to whatever your AOC directory is

alias aos="python3 solution.py < in.txt"
alias aot="printf '\033[34m'; python3 solution.py < test.txt; printf '\033[m'"
alias aoc="aot; echo; aos"

aocload () {
	local dir
	local year
	local day

	this_year="$(date "+%Y")"
	this_day="$(date "+%d" | sed -e 's/^0//')"
    if [ -n "${1}" ]; then
		if [ -z "${2}" ]; then
			printf '\033[31m%s\033[m\n' 'Expected one more parameter (day)'
			return 1
		fi
		if [ -n "${3}" ]; then
			printf '\033[31m%s\033[m\n' 'Expected exactly 2 parameters (year day)'
			return 2
		fi
		year="${1}"
		day="${2}"
		if [ "${day}" -lt "1" -o "${day}" -gt "25" ]; then
			printf '\033[31m%s\033[m\n' 'Day not in range 1..25'
			return 3
		fi
		if [ "${year}" -lt "2015" -o "${year}" -gt "${this_year}" ]; then
			printf '\033[31m%s\033[m\n' "Year not in range 2015..${this_year}"
			return 4
		fi
    else
		year="${this_year}"
		day="${this_day}"
    fi
	dir="${AOC_DIR}/${year}/${day}"

	command mkdir -p -- "${dir}" || return 5
	command cd -P -- "${dir}" || return 6
	2>/dev/null 1>/dev/null git init "${AOC_DIR}" || true

	. "${AOC_DIR}/.env"
	curl -sSL \
		-o './in.txt' \
		-b "session=${AOC_COOKIE}" \
		"https://adventofcode.com/${year}/day/${day}/input" \
		|| printf '\033[31m%s\033[m' "$(echo 'Error downloading input' | tee './in.txt')"
	command unset -v -- AOC_COOKIE

	if [ ! -f './solution.py' ]; then
		command cat <<- TEMPLATE >> './solution.py'
			#!/usr/bin/env python3

			print()

			import os
			import re
			import sys
			import math
			import multiprocessing as mp
			from copy import copy, deepcopy
			from typing import Any
			import numpy as np
			import more_itertools as miter
			from functools import cache, lru_cache, reduce
			from collections import deque, defaultdict, Counter
			from itertools import (
			    repeat, cycle, combinations, combinations_with_replacement,
			    permutations, tee, pairwise, zip_longest, islice, takewhile,
			    filterfalse, starmap
			)
			e=enumerate

			data = open(0).read().strip().splitlines()
			R = len(data)
			C = len(data[0])
			def parse_grid(data: list[str]) -> Any:
			    for r in range(R):
			        for c in range(C):
			            pass
			def parse_lines(data: list[str]) -> Any:
			    for line in data:
			        line = line.split()
			def parse_line(data: list[str]) -> Any:
			    return data[0].split()
			# data = parse_line(data)
			# data = parse_lines(data)
			data = parse_grid(data)

			t = 0
			for line in data:
			    n = 0
			    t += n
			print(t)
		TEMPLATE
	fi

	command chmod +x './solution.py'
	tmux splitw -v -c "${dir}"
	tmux send-keys "nvim '+normal gg0' './in.txt'" ENTER
	tmux select-pane -l
	tmux send-keys "nvim './solution.py'" ENTER
}
