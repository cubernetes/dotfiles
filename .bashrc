#! /bin/bash --
# ex: set ts=4 sw=4 ft=sh

# Exit when noninteractive. This is more portable than checking PS1.
[ "${-#*i}" = "${-}" ] && return

############################ utils (thanks rwxrob) #############################
_path_lookup () { type -P "$1" ; } # adapted for bash.
_have_all () { while [ $# -gt 0 ] ; do [ -x "$(_path_lookup "$1")" ] || return 1 ; shift ; done ; }
_have () { _have_all "$1" ; }
_source_if () { [ -f "$1" ] && [ -r "$1" ] && . "$1" ; }

# TODO: Create ~/.local/bin directory and add ~/.local/bin to PATH
# Add some basic scripts, like log.log, etc.
################################ logging utils #################################
log.log () {
	case "${1-}" in
		red) __ansi='41;30'    ;;
		orange) __ansi='43;30' ;;
		blue) __ansi='44;30'   ;;
		green) __ansi='42;30'  ;;
		*) __ansi='45;30'      ;;
	esac
	shift
	1>&2 printf "\033[${__ansi}m%s\033[m\n" "${*}"
	unset __ansi
}
log.err () { log.log red "${@}" ; }
log.warn () { log.log orange "${@}" ; }
log.info () { log.log blue "${@}" ; }
log.good () { log.log green "${@}" ; }

###################### exit when already sourced (posix) #######################
[ -n "${BASHRC_SOURCED}" ] && { log.err ".bashrc already sourced. Reset shell with 'exec bash [-l]' or start a new terminal." ; return 1 ; }
BASHRC_SOURCED='1'

################################## bash reset ##################################
# Set IFS to the default value, <space><tab><newline>
IFS=' 	
'
# 'unset' could be an alias AND a function. '\unset' prevents alias lookup,
# and bash in posix mode (thus the variable below) prioritizes special builtins
# (such as unset) before functions. This is the only way to guarantee calling
# the actual unset builtin, with which we can unset the unalias builtin,
# and then unalias everything.
POSIXLY_CORRECT='1'
__COMMANDS=(builtin unalias unset read printf command exit type tr fc compgen wc sed grep xargs sudo shopt kill ps head awk clear curl wget source check mv mkdir rm rmdir while do done cc gcc clang basename clone42 git alias export pwd docker shift until for in bash sh dash ash ksh zsh top shellcheck watch cmatrix alacritty tmux zellij ssh which date df du case esac crontab ping base64 apt paru pacman yum dnf aptitude yay rpm dpkg env awk apropos help dirname bc dc break continue unzip zip tar untar gzip gunzip xz unxz base32 cal chattr cfdisk fdisk passwd chroot cmp cron split dd df dir declare diff dircolors dmesg eval complete exec egrep false true fg bg free fold find file gawk groupadd less more cat head tail chmod chown history trap sleep yes useradd adduser addgroup usermod groupdel userdel xxd groups users who w last hash hostname htop ip ifconfig install ifdown ifup jobs killall pkill pgrep klist link ln unlink let local logout logname lsblk lsof pidof lspci lsusb lscpu make mktemp mount umount nc ncat nmap nft iptables ufw nl nslookup open whereis whatis write wall agetty amixer pulsemixer ar cmake bzip2 ccrypt chvt column chsh ex od pushd popd pv pvs lvs vgs rsync screen sed seq wait ftp sftp shift shuf sort uniq su strace sync tee test time trap tr tty ulimit umask unix2dos dos2unix uptime paco francinette cd ls disown whoami reboot systemctl shutdown poweroff set x touch stat cp scp man locate xset kbdrate return cut batcat id ed v vi vim nvim nano skill norminette bat echo if then fi else function PROMPT_COMMAND PS0 PS1 PS2 PS3 PS4 tabs xmodmap lesspipe CDPATH dotconf pomo dp p r q-dig l ll ls ipa wpa_restart preexec precmd)
__ALL_COMMANDS=("${__COMMANDS[@]}" . : g++ firewall-cmd apt-get xdg-open) # names that are not alnum
2>/dev/null \unset -- "${__ALL_COMMANDS[@]}"
2>/dev/null \unalias -- "${__ALL_COMMANDS[@]}"
hash -r
unalias -a
unset POSIXLY_CORRECT

######################## path append & prepend (posix) #########################
pathvarprepend () {
	# prepending paths to pathvar denoted by the expansion of the PATHVAR parameter
	# if it's already in the PATH, move it to the end
	# POSIX compliant version

	test $# -ge 2 ||
		{ log.info "Usage: pathvarprepend PATHVAR PATH_TO_ADD [PATH_TO_ADD...]" ;
		log.info "Example: pathvarprepend LD_LIBRARY_PATH '$HOME/.local/lib' '/usr/local/lib'" ;
		return 2 ; }

	pathvar=$1
	shift

	case $pathvar in (*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*|""|[0123456789]*) false;; esac ||
		{ log.err 'Expanded pathvar is not a valid name/variable identifier' ; return 3 ; }

	if [ "$pathvar" = "PATH" ] ; then
		test "${-#*r}" = $- ||
			{ log.err 'Restricted shell, cannot change PATH' ; return 4 ; }
	fi

	path_prepend_error=0

	# Thanks Stephane
	code='set -- dummy'
	n=$#
	while [ "$n" -gt 0 ] ; do
		code="$code \"\${$n}\""
		n=$((n - 1))
	done
	eval "$code"

	while shift ; [ $# -gt 0 ] ; do
		norm_path_to_add=$1

		test "${norm_path_to_add#*:}" = "$norm_path_to_add" ||
			{ log.warn "Cannot add path with colon: $norm_path_to_add" ; path_prepend_error=1 ; continue ; }

		test -d "$norm_path_to_add" ||
			{ log.warn "path_to_add ('$norm_path_to_add') not a directory" ; path_prepend_error=1 ; continue ; }

		norm_path=$(printf %s ":$(eval "printf %s "'"'"\$$pathvar"'"'):" | head -n 1 | sed 's|/\+|/|g; s/\/$//; s/:/::/g') # fence with colons, ensure one line, deduplicate slashes, trim trailing, duplicate colons
		norm_path_to_add=$(printf %s "$norm_path_to_add" | head -n 1 | sed 's|/\+|/|g; s/\/$//') # ensure one line, deduplicate slashes, trim trailing
		exec 3<<- 'EOF'
			# escape BRE meta-characters
			s/\\/\\./g # backslash first
			s/\./\\./g
			s/\^/\\^/g
			s/\$/\\$/g
			s/\*/\\*/g
			s/\[/\\[/g
			s|/|\\/|g # escape delimiter for outer sed
		EOF
		norm_path=$(printf %s "$norm_path" | sed "s/:$(printf %s "$norm_path_to_add" | sed -f /proc/self/fd/3 3<&3)://g") # remove all instances of PATH_TO_ADD from PATH
		exec 3<&-
		norm_path=$(printf %s "$norm_path" | sed 's/:\+/:/g; s/^://; s/:$//') # deduplicate colons, trim leading and trailing
		eval "$pathvar=\$norm_path_to_add\${norm_path:+:\$norm_path}" # prepend with colon
	done
	return $path_prepend_error
}

pathvarappend () {
	# appending paths to pathvar denoted by the expansion of the PATHVAR parameter
	# if it's already in the PATH, move it to the end
	# POSIX compliant version

	test $# -ge 2 ||
		{ log.info "Usage: pathvarappend PATHVAR PATH_TO_ADD [PATH_TO_ADD...]"
		log.info "Example: pathvarappend LD_LIBRARY_PATH '$HOME/.local/lib' '/usr/local/lib'"
		return 2 ; }

	pathvar=$1

	case $pathvar in (*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*|""|[0123456789]*) false;; esac ||
		{ log.err 'Expanded pathvar is not a valid name/variable identifier' ; return 3 ; }

	if [ "$pathvar" = "PATH" ] ; then
		test "${-#*r}" = $- ||
			{ log.err 'Restricted shell, cannot change PATH' ; return 4 ; }
	fi

	path_append_error=0

	while shift ; [ $# -gt 0 ] ; do
		norm_path_to_add=$1

		test "${norm_path_to_add#*:}" = "$norm_path_to_add" ||
			{ log.warn 'Cannot add path with colon' ; path_append_error=1 ; continue ; }

		test -d "$norm_path_to_add" ||
			{ log.warn "path_to_add ('$norm_path_to_add') not a directory" ; path_append_error=1 ; continue ; }

		norm_path=$(printf %s ":$(eval "printf %s "'"'"\$$pathvar"'"'):" | head -n 1 | sed 's|/\+|/|g; s/\/$//; s/:/::/g') # fence with colons, ensure one line, deduplicate slashes, trim trailing, duplicate colons
		norm_path_to_add=$(printf %s "$norm_path_to_add" | head -n 1 | sed 's|/\+|/|g; s/\/$//') # ensure one line, deduplicate slashes, trim trailing
		exec 3<<- 'EOF'
			# escape BRE meta-characters
			s/\\/\\./g # backslash first
			s/\./\\./g
			s/\^/\\^/g
			s/\$/\\$/g
			s/\*/\\*/g
			s/\[/\\[/g
			s|/|\\/|g # escape delimiter for outer sed
		EOF
		norm_path=$(printf %s "$norm_path" | sed "s/:$(printf %s "$norm_path_to_add" | sed -f /proc/self/fd/3 3<&3)://g") # remove all instances of PATH_TO_ADD from PATH
		exec 3<&-
		norm_path=$(printf %s "$norm_path" | sed 's/:\+/:/g; s/^://; s/:$//') # deduplicate colons, trim leading and trailing
		eval "$pathvar=\${norm_path:+\$norm_path:}\$norm_path_to_add" # append with colon
	done
	return $path_append_error
}

path_append () {
	pathvarappend PATH "$@"
}

ld_lib_path_append () {
	pathvarappend LD_LIBRARY_PATH "$@"
}

cdpath_append () {
	pathvarappend CDPATH "$@"
}

path_prepend () {
	pathvarprepend PATH "$@"
}

ld_lib_path_prepend () {
	pathvarprepend LD_LIBRARY_PATH "$@"
}

cdpath_prepend () {
	pathvarprepend CDPATH "$@"
}

################################# bash options #################################
shopt -s autocd
shopt -s extglob
shopt -s checkwinsize

############################ bash history options #############################
shopt -s lithist
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -u histverify

############################# better bash history ##############################
# readonly BASH_SESSION_NAME="${__COMMANDS[$(( RANDOM % ${#__COMMANDS[@]}))]}_${__COMMANDS[$(( RANDOM % ${#__COMMANDS[@]}))]}_${__COMMANDS[$(( RANDOM % ${#__COMMANDS[@]}))]}"
readonly BASH_SESSION_NAME="${$}"
HISTSIZE='-1'
HISTFILESIZE='-1'
REAL_HISTFILE="${HOME}/.better_bash_history/.bash_history_$(printf "%(%Y-%m-%d)T")_daily"
HISTFILE="${HOME}/.better_bash_history/.bash_history_$(printf '%(%Y-%m-%d-%H-%M-%S)T')_${BASH_SESSION_NAME}"
HISTDIR="$(dirname -- "$HISTFILE")"
HISTTIMEFORMAT=$'\033[m%F %T: '
HISTCONTROL='ignoreboth'
history -c
history -r -- "${REAL_HISTFILE}"
write_history () {
	[ -d "${REAL_HISTFILE}" ] || { rm -f -- "$(dirname -- "${REAL_HISTFILE}")" && mkdir -p -- "$(dirname -- "${REAL_HISTFILE}")" ; }
	[ -f "${HISTFILE}" ] &&
		[ -r "${HISTFILE}" ] &&
		<"${HISTFILE}" 1>/dev/null tee -a -- "${REAL_HISTFILE}" &&
		rm -f -- "${HISTFILE}"
} && trap 'write_history' EXIT

############################# VIM ALIASES (posix) ##############################
if _have nvim ; then
	alias vi="$(_path_lookup nvim)"
elif _have vim ; then
	alias vi="$(_path_lookup vim)"
elif _have nvi ; then
	alias vi="$(_path_lookup nvi)"
elif _have vi ; then
	alias vi="$(_path_lookup vi)"
elif _have nano ; then
	alias vi="$(_path_lookup nano)"
fi
alias v='log.err use vi'
alias vim='log.err use vi'
alias nvim='log.err use vi'

######################## default-option aliases (posix) ########################
alias gdb='gdb -q'
alias tmux='tmux -2'
alias less='less -SR'
alias free='free -mht'
alias sl='sl -GwFdcal'
alias ip='ip -color=auto'
alias grep='grep --color=auto'
alias tree='tree --dirsfirst -C'
alias pacman='pacman --color=auto'
alias cmatrix='cmatrix -u3 -C red'
alias diff='diff --width="${COLUMNS:-80}" --color=auto'
alias ls='ls --width="${COLUMNS:-80}" --color=auto -bC'
alias objdump='objdump --disassembler-color=extended-color -Mintel'
alias dmesg='dmesg --color=auto --reltime --human --nopager --decode'
alias sudo='sudo ' # trailing space means complete aliases
alias watch='watch -tcn.1 ' # trailing space means complete aliases

########################## overwrite aliases (posix) ###########################
alias make='compiledb make'

########################## navigation aliases (posix) ##########################
alias r='ranger'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

########################### general aliases (posix) ############################
alias svi='sudo vi'
alias open='xdg-open'
alias dp='declare -p'
alias wttr='curl -sfkSL wttr.in'
alias ipa='ip -br -color=auto a'
alias xcopy='xsel --clipboard --input'
alias xpaste='xsel --clipboard --output'
alias paco='"${HOME-}"/francinette/tester.sh'
alias pcker='nvim "${HOME-}"/.config/nvim/lua/*'
alias francinette='"${HOME-}"/francinette/tester.sh'
alias q-dig='docker run --rm -it ghcr.io/natesales/q'
alias q='duck'
alias after='nvim "${HOME-}"/.config/nvim/after/plugin'
alias dotconf='git --git-dir="${HOME-}"/.dotfiles/ --work-tree="${HOME-}"'
alias ll='\ls --width="${COLUMNS:-80}" --sort=time --time=mtime --color=auto --fu -bharZ1l'
alias l='\ls --width="${COLUMNS:-80}" --sort=time --time=mtime --color=auto --time-style=long-iso -bharZ1l'
alias colors='bash -c "$(curl -sfkSL "https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw")"'
alias s='echo sudo $(fc -nl -2 | head -1 | cut -c3-) ; eval sudo $(fc -nl -2 | head -1 | cut -c3-)' # cut -c2- for bash posix mode

############################### CDPATHS (posix) ################################
CDPATH="."\
":${HOME}"\
":${HOME}/onnea"\
":${HOME}/42ecole"\
":${HOME}/projects"\
":${HOME}/projects/aoc"\
":${HOME}/42ecole/42cursus"\
":${HOME}/projects/aoc/2023"

################################## FUNCTIONS ###################################
################################# vix (posix) ##################################
vix () {
	_have vi || { log.err 'vi missing' ; exit 1 ; }

	[ "${#}" -lt "1" ] && { log.info "Usage: vix FILE [VIM_ARGS...]" ; return 1 ; }

	file="${1}"
	shift
	[ -e "$file" ] && [ ! -f "$file" ] && { log.err "File '$file' exists and is not a regular file" ; return 2 ; }
	if [ ! -e "$file" ] ; then
		printf "#! /bin/sh -\n\n\n" > "$file" || { log.err "Can't write to file '$file'" ; return 3 ; }
		set -- "$@" +3
	fi
	if [ ! -x "$file" ] ; then
		chmod +x "$file" || { log.err "Can't chmod +x '$file'" ; return 4 ; }
	fi
	vi "$@" "$file"
}

##################### cd with pushd functionality (posix) ######################
cd () {
	command cd "${@}" || return 1
	pwd="${PWD}"
	1>/dev/null command cd - || return 1
	1>/dev/null pushd "${pwd}" || return 1
}

############################## vimw (posix) ###############################
# Roughly equivalent to vi "$(which "$1")", but also allowing for args after $1
vimw () {
	_have vi || { log.err 'vi missing' ; exit 1 ; }

	[ -z "$1" ] && { log.info "Usage: vimw FILE [VIM_ARGS...]" ; return 1 ; }

	first="$1"
	shift
	vi "$@" "$(type -P "$first")"
}

#################################### paruuu (posix) ####################################
# Update arch linux system with pacman, paru and ssid whitelist
# Clears cache and removes orphans. Arguably dangerous.
# Depends on iw, paru, pacman, rankmirrors, sudo, curl
paruuu () {
	_have iw || { log.err 'iw missing' ; exit 1 ; }
	_have paru || { log.err 'paru missing' ; exit 2 ; }
	_have pacman || { log.err 'pacman missing' ; exit 3 ; }
	_have rankmirrors || { log.err 'rankmirrors missing' ; exit 4 ; }
	_have sudo || { log.err 'sudo missing' ; exit 5 ; }
	_have curl || { log.err 'curl missing' ; exit 6 ; }

	printf 'Do system upgrade (Y) or exit (n): '
	read -r choice
	[ ! "${choice}" = "y" ] && [ ! "${choice}" = "Y" ] && [ -n "${choice}" ] && exit 7
	ssid="$(iw dev wlan0 link |
			grep SSID |
			sed -e 's/[[:blank:]]*SSID: //'       \
				-e 's/[[:blank:]]*$//'
	)"
	if :                                          \
		&& [ -n "${ssid-}" ]                      \
		&& [ ! "${ssid-}" = "∞" ]                 \
		&& [ ! "${ssid-}" = "Haihin" ]            \
		&& [ ! "${ssid-}" = "Hackme" ]            \
		&& [ ! "${ssid-}" = "Rudolph" ]           \
		&& [ ! "${ssid-}" = "hackme3" ]           \
		&& [ ! "${ssid-}" = "FreeWifi" ]          \
		&& [ ! "${ssid-}" = "Nichts 5" ]          \
		&& [ ! "${ssid-}" = "Free Wifi" ]         \
		&& [ ! "${ssid-}" = "DS_JD-Tree" ]        \
		&& [ ! "${ssid-}" = "Nichts 2,4" ]        \
		&& [ ! "${ssid-}" = "WLAN-17KA15" ]       \
		&& [ ! "${ssid-}" = "\xe2\x88\x9e" ]      \
		&& [ ! "${ssid-}" = $'\xe2\x88\x9e' ]     \
		&& [ ! "${ssid-}" = "Pink Flamingo" ]     \
		&& [ ! "${ssid-}" = "42Berlin_Guest" ]    \
		&& [ ! "${ssid-}" = "Silmaril 4 (5)" ]    \
		&& [ ! "${ssid-}" = "Pink Flamingo_5G" ]  \
		&& [ ! "${ssid-}" = "42Berlin_Student" ]  \
		&& [ ! "${ssid-}" = "Silmaril 4 (2.4)" ]  \
		&& [ ! "${ssid-}" = "ZorgatiHome Guest" ] \
	&& : ; then
		printf "\033[31mYou're connected to '${ssid}', update anyway (Y|n)?: \033[m"
		read -r choice
		[ ! "${choice}" = "y" ] && [ ! "${choice}" = "Y" ] && [ -n "${choice}" ] && exit 8
	fi
	time (
		printf '\033[30;41m%s\033[m\n' 'Cache credentials for sudo:'                                          \
			&& sudo -v                                                                                        \
			&& printf '\033[30;41m%s\033[m\n' 'Updating mirrorlist'                                           \
			&& curl -sfkSL "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" \
				| sed -e 's/^#Server/Server/' -e '/^#/d'                                                      \
				| rankmirrors -n 8 -                                                                          \
				| sudo tee /etc/pacman.d/mirrorlist                                                           \
			&& clear                                                                                          \
			&& printf '\033[30;41m%s\033[m\n' 'pacman -Sy archlinux-keyring'                                  \
			&& yes | sudo pacman -Sy archlinux-keyring                                                        \
			&& printf '\033[30;41m%s\033[m\n' 'pacman -Syyuu --noconfirm'                                     \
			&& yes | sudo pacman -Syyuu --noconfirm                                                           \
			&& printf '\033[30;41m%s\033[m\n' 'paru -Syyu --devel --noconfirm'                                \
			&& yes | paru -Syyu --devel --noconfirm                                                           \
			&& printf '\033[30;41m%s\033[m\n' 'pacman -Qtdq | pacman -Rns -'                                  \
			&& { pacman -Qtdq | 2>/dev/null sudo pacman --noconfirm -Rns -                                    \
			|| printf '\033[30;42m%s\033[m\n' 'No pacman orphan packages :)!' ; }                             \
			&& yes | paru -Scc -d                                                                             \
		&& printf '\n\033[30;42m%s\033[m\n' '###### Done without error ######'                                \
		|| printf '\n\033[30;41m%s\033[m\n' '###### Some error occured! ######'
	)
}

################################ skill (posix) #################################
# Depends on pgrep, ps
skill () {
	_have pgrep || { log.err 'pgrep missing' ; return 1 ; }
	_have ps || { log.err 'ps missing' ; return 2 ; }

	exit_status=0
	while [ -n "${1-}" ] ; do
		# pids="$(ps -eo pid,cmd)"
		# pids="$(echo "$pids" | cut -d " " -f3- | grep -n -- "$1" | cut -d ":" -f1 | awk 'BEGIN{printf "NR=="}ORS="||NR=="' | head -n 1 | pids="$pids" xargs --no-run-if-empty -I {} bash -c 'echo "$pids" | cut -d " " -f2 | awk "${1}0"' bash {})"
		pgrep -f -- "$1" | xargs -r kill -9 && return 0 || {
			printf '\033[31m%s\033[m\n' "These processes couldn't be killed without sudo:"
			pgrep -f "$1" | xargs ps -o user,ruser,pid,c,stime,tty,time,cmd
		}
		pgrep -f -- "$1" | sudo xargs -r kill -9 || {
			if [ $? -ne 1 ] ; then
				printf '\033[41;30m%s\033[m\n' "These processes couldn't be killed with root (sudo):"
				pgrep -f "$1" | xargs ps -o user,ruser,pid,c,stime,tty,time,cmd
			else
				log.info Cancelled
				return 3 ;
			fi
			exit_status=1
		}
		shift
	done
	return $exit_status
}

############################# wpa_restart (posix) ##############################
# Depends on wpa_supplicant
wpa_restart () {
	_have wpa_supplicant || { log.err 'wpa_supplicant missing' ; return 1 ; }

	skill wpa_supplicant
	sudo wpa_supplicant -B -i "${1:-wlan0}" -c /etc/wpa_supplicant/wpa_supplicant.conf
}

##################################### bat ######################################
bat () {
	1>/dev/null 2>&1 command -v batcat && { $(type -P batcat) "${@}" ; return 0 ; }
	1>/dev/null 2>&1 command -v bat && { $(type -P bat) "${@}" ; return 0 ; }
	$(type -P cat) "${@}"
}

################################# take (posix) #################################
take () {
	mkdir -p -- "$1" &&
		cd -P -- "$1" ||
		return 1 ;
}

################################## norminette ##################################
# Depends on norminette
norminette () {
	local vers
	local newst

	_have norminette || { log.err 'norminette missing' ; return 1 ; }

	vers="$($(type -P norminette) -v | cut -d" " -f2)"
	newst='3.3.55'
	if [ ! "${vers-}" = "${newst-}" ] ; then
		printf "%s\n%b\n" "Norminette v${vers-} instead of v${newst-} detected."\
			'\033[31mPlease up-/downgrade\033[m'
	fi
	$(type -P norminette) -R CheckForbiddenSourceHeader "${@}"
}

################################ __norm (posix) ################################
# Depends on git, norminette
__norm () {
	_have git || { log.err 'git missing' ; return 1 ; }
	_have norminette || { log.err 'norminette missing' ; return 2 ; }

	__pwd="$(pwd -P)"
	[ -n "${__pwd}" ] && [ -z "${__pwd##${HOME-}/42/42cursus/*}" ] || { return 1 ; }
	1>/dev/null 2>&1 git status || { return 2 ; }
	1>/dev/null 2>&1 norminette && printf ' \033[92m%s\033[m' "[Norm: OK]" || printf ' \033[101;37m%s\033[m' "[䝝誒 ‼ NORM ‼ 屌誒]"
	return 0
}

############################### ft_check (posix) ###############################
# Depends on git, norminette
ft_check () {
	# Set params
	URL="${1}"
	DIR="/tmp/tmp_repo_$(date +%s)"

	_have git || { log.err 'git missing' ; return 1 ; }
	_have norminette || { log.err 'norminette missing' ; return 2 ; }

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

############################### clone42 (posix) ################################
# Depends on git, norminette
clone42 () {
	folder="${1}"
	repo_url="${2}"

	_have git || { log.err 'git missing' ; return 1 ; }
	_have norminette || { log.err 'norminette missing' ; return 2 ; }

	git clone --quiet "${repo_url}" "${folder}" && {
		cd "${folder}"
		norminette -R CheckForbiddenSourceHeader "."
	} || { printf '%s\n' "Could not clone repo!" ; }
}

################################# ENVIRONMENT ##################################
export GIT_SSH_COMMAND='ssh -oIdentitiesOnly=yes -F"${HOME-}"/.ssh/config'

export LANG='en_US.UTF-8'
export USER="${USER:-$(whoami)}"

export EDITOR="$({	type -P nvim ||
					type -P vim  ||
					type -P vi   ||
					type -P nvi  ||
					type -P hx   ||
					type -P nano ||
					type -P ex   ||
					type -P ed ; } 2>/dev/null)"
export VISUAL="${EDITOR-}"
export SUDO_EDITOR="${EDITOR-}"

export MANPAGER='nvim +Man!'
# export MANPAGER='less -X'

export BAT_THEME='gruvbox-dark'
# export BAT_THEME='gruvbox-light'

[ -n "${DISPLAY-}" ] || log.warn 'DISPLAY not set'

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

################################ BASH PRE-EXEC #################################
if [ ! -f "${HOME}"/.bash-preexec.sh ] ; then
	curl -sfkSL "https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh" -o "${HOME}"/.bash-preexec.sh
fi

. "${HOME}"/.bash-preexec.sh

preexec() {
	[ -d "${HISTDIR}" ] || { mkdir -p -- "${HISTDIR}" || log.warn "Can't create directory: ${HISTDIR}" ; }
	history -a
	TIMESTAMP_BEFORE="$(date +%s)"
}
precmd() {
	local sec_diff
	local TIMESTAMP_NOW

	TIMESTAMP_NOW="$(date +%s)"
	sec_diff="$((TIMESTAMP_NOW - TIMESTAMP_BEFORE))"
	if [ -n "${TIMESTAMP_BEFORE-}" ] && [ "${sec_diff-}" -ge "5" ] ; then
		TOOK_STRING=' took '
		mins="$((sec_diff / 60))"
		secs="$((sec_diff % 60))"
		if [ "${mins-}" -eq "0" ] ; then
			TOOK_STRING="${TOOK_STRING-}${secs-}s"
		else
			TOOK_STRING="${TOOK_STRING-}${mins-}m${secs-}s"
		fi
	else
		unset -v -- TOOK_STRING
	fi
}

#################################### PROMPT ####################################
GIT_PS1_SHOWDIRTYSTATE='1'
GIT_PROMPT='1'
if [ ! -f "${HOME}"/git-prompt.sh ] && [ "${GIT_PROMPT-}" -eq "1" ] ; then
	curl -sfkSL "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" -o "${HOME}"/git-prompt.sh
fi

_PS1_CWD_CLR='\[\033[33m\]'
_PS1_USER='\[\033[31m\]\u\[\033[m\]'
_PS1_SSH="$(
	set | grep -sq ^SSH_CONNECTION && printf "@\[\033[36m\]%s\[\033[m\]" "ssh"
)"
_PS1_TMUX="$(
	set | grep -sq ^TMUX_PANE && printf "@\[\033[35m\]%s\[\033[m\]" "tmux"
)"
[ -n "${_PS1_SSH-}" ] &&	_PS1_HOST_CLR='\[\033[30;42m\]' || \
							_PS1_HOST_CLR='\[\033[32m\]'
_PS1_1="${_PS1_USER-}"
_PS1_1="${_PS1_1-}@${_PS1_HOST_CLR-}"
_PS1_1="${_PS1_1-}\h\[\033[m\]"
_PS1_1="${_PS1_1-}${_PS1_SSH-}${_PS1_TMUX-} "
_PS1_1="${_PS1_1-}${_PS1_CWD_CLR-}"
_PS1_1="${_PS1_1-}[\w]\${TOOK_STRING-}"
_PS1_GIT='\[\033[m\]\[\033[36m\]$(__git_ps1 " (%s)")'
# _PS1_2='\[\033[m\]\[\033[36m\]$(__norm)\[\033[m\]\n\[\033[35m\]~\$\[\033[m\] '
_PS1_2='\[\033[m\]\[\033[36m\]\[\033[m\]\n\[\033[35m\]~\$\[\033[m\] '

if [ -f "${HOME}"/git-prompt.sh ] &&	[ -r "${HOME}"/git-prompt.sh ] && \
										[ "${GIT_PROMPT-}" -eq "1" ] ; then
	. "${HOME}"/git-prompt.sh
	PS1="${_PS1_1-}${_PS1_GIT-}${_PS1_2-}"
else
	PS1="${_PS1_1-}${_PS1_2-}"
fi

# Autoclear
# If bash runs in posix mode, if should be `cut -c2-' instead
# PS0='$(clear -x ; printf "${PS1@P}" ; fc -nl -1 | cut -c3- ; printf "\n")'

# Simplified *Bash* Prompt, e.g. for tty/system/linux console
# unset PROMPT_COMMAND PS0 ; PS1='\033[94m\u\033[37m@\033[32m\h\033[37m@\033[33m$(basename -- "$(tty)") \033[36m\w \033[35m\$\033[m '

# Show shell level
# PS1='[${SHLVL}] '"${PS1}"

# ##################################### AOC ######################################
AOC_DIR="${HOME}/projects/aoc" # remember to change this to whatever your AOC directory is
alias aos='< in.txt python3 solution.py'
alias aot='< test.txt printf '\033[34m' ;  python3 solution.py ; printf '\033[m''
alias aoc='aot ; echo ; aos'

################################### aocload ####################################
# Depends on curl, tmux, git
aocload () {
	local dir
	local year
	local day

	_have curl || { log.err 'curl missing' ; exit 1 ; }
	_have tmux || { log.err 'tmux missing' ; exit 2 ; }
	_have git || { log.err 'git missing' ; exit 3 ; }

	this_year="$(date "+%Y")"
	this_day="$(date "+%d" | sed -e 's/^0//')"
	if [ -n "${1}" ] ; then
		if [ -z "${2}" ] ; then
			printf '\033[31m%s\033[m\n' 'Expected one more parameter (day)'
			return 1
		fi
		if [ -n "${3}" ] ; then
			printf '\033[31m%s\033[m\n' 'Expected exactly 2 parameters (year day)'
			return 2
		fi
		year="${1}"
		day="${2}"
		if [ "${day}" -lt "1" -o "${day}" -gt "25" ] ; then
			printf '\033[31m%s\033[m\n' 'Day not in range 1..25'
			return 3
		fi
		if [ "${year}" -lt "2015" -o "${year}" -gt "${this_year}" ] ; then
			printf '\033[31m%s\033[m\n' "Year not in range 2015..${this_year}"
			return 4
		fi
	else
		year="${this_year}"
		day="${this_day}"
	fi
	dir="${AOC_DIR}/${year}/${day}"

	mkdir -p -- "${dir}" || return 5
	cd -P -- "${dir}" || return 6
	2>/dev/null 1>&2 git init "${AOC_DIR}" || true

	. "${AOC_DIR}/.env"
	curl -sfkSL                                             \
		-o './in.txt'                                       \
		-b "session=${AOC_COOKIE}"                          \
		"https://adventofcode.com/${year}/day/${day}/input" \
		|| printf '\033[31m%s\033[m' "$(log.err 'Error downloading input' | tee './in.txt')"
	unset -v -- AOC_COOKIE

	if [ ! -f './solution.py' ] ; then
		cat <<- TEMPLATE >> './solution.py'
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

	chmod +x './solution.py'
	tmux splitw -v -c "${dir}"
	tmux send-keys "nvim '+normal gg0' './in.txt'" ENTER
	tmux select-pane -l
	tmux send-keys "nvim './solution.py'" ENTER
}

############################## TERMINAL SETTINGS ###############################
tabs -4
set -o emacs
_have lesspipe && eval "$(SHELL=/bin/sh lesspipe)"

# Key Repeat/Delay Rate
_have xset && 2>/dev/null xset r rate 200 60
# _have kbdrate && sudo kbdrate --rate=30.0 --delay=250

# Disable bell
_have xset && 2>/dev/null xset -b

################################# COMPLETIONS ##################################
complete -F _command vimw

_source_if "${HOME}/.userbashrc"
