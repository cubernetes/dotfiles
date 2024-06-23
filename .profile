#! /bin/bash --
# ex: set ts=4 sw=4 ft=sh

# TODO: Make more general purpose, currently quite bashy

# TODO: Create ~/.local/bin directory and add ~/.local/bin to PATH
# Add some basic scripts, like log.log, etc.
############################ logging utils (posix) #############################
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

if [ -n "${PROFILE_SOURCED}" ] ; then
###################### exit when already sourced (posix) #######################
	log.err ".profile already sourced. unset PROFILE_SOURCED to force reloading, or don't start a login session (e.g. leave the -l flag from bash)."
else
########################## global environment (posix) ##########################
	if ! [ -n "${USER-}" ] ; then
	if ! USER="$(2>/dev/null ps -o user= -p "${$}" | awk '{print $1}')" ; then
	if ! USER="$(2>/dev/null whoami)" ; then
	if ! USER="$(2>/dev/null id -u -n)"; then
	if ! USER="$(basename -- "$({HOME=~ && printf %s "${HOME}")")" ; then
	if ! USER="$(2>/dev/null logname)" ; then
	if USER="${LOGNAME-}" ; [ -z "${USER}" ] ; then
	unset USER
	fi; fi; fi; fi; fi; fi; fi

	if ! [ -n "${HOME-}" ] ; then
	if ! HOME="$(getent passwd "$(id -u "${USER}")" | cut -d: -f6)" ; then
	if ! HOME="$(getent passwd "${UID}" | cut -d: -f6)" ; then
	if ! HOME="$(awk -v FS=':' -v user="${USER}" '($1==user) {print $6}' "/etc/passwd")" ; then
	unset HOME
	HOME=~
	if [ "${HOME}" = "~" ] ; then
	if ! mkdir "/tmp/${USER}" && HOME="/tmp/${USER}" ; then
	unset HOME
	fi; fi ; fi ; fi ; fi; fi

	export EDITOR="$({	type -P nvim ||
						type -P vim  ||
						type -P vi   ||
						type -P nvi  ||
						type -P hx   ||
						type -P nano ||
						type -P ex   ||
						type -P ed ; } 2>/dev/null)"
	export _JAVA_AWT_WM_NONREPARENTING="1"
	export GIT_SSH_COMMAND="ssh -oIdentitiesOnly=yes -F"${HOME}"/.ssh/config"
	export LANG="en_US.UTF-8"
	export VISUAL="${EDITOR}"
	export SUDO_EDITOR="${EDITOR}"
	export XDG_RUNTIME_DIR="/run/user/$(id -u)"
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
	export GIT_CONFIG_GLOBAL="${HOME}/.gitconfig"
	export USER42="tischmid"
	export EMAIL42="timo42@proton.me"
	export MAIL="timo42@proton.me"
	export GOPATH="${HOME}/go"
	MANPAGER="nvim +Man!" # MANPAGER="less -X"
	export MANPAGER
	export PATH
	export LD_LIBRARY_PATH

	####################### path append & prepend functions ########################
	pathvarprepend () {
		# prepending paths to pathvar denoted by the expansion of the PATHVAR parameter
		# if it's already in the PATH, move it to the end
		# POSIX compliant version

		test -n "${2}" ||
			{ log.info "Usage: pathvarprepend PATHVAR PATH_TO_ADD [PATH_TO_ADD...]";
			log.info "Example: pathvarprepend LD_LIBRARY_PATH '${HOME}/.local/lib' '/usr/local/lib'";
			return 2; }

		pathvar="${1}"
		shift

		case $pathvar in (*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*|""|[0123456789]*) false;; esac ||
			{ log.err 'Expanded pathvar is not a valid name/variable identifier'; return 3; }

		if [ "$pathvar" = "PATH" ]; then
			test "${-#*r}" = "${-}" ||
				{ log.err 'Restricted shell, cannot change PATH'; return 4; }
		fi

		path_prepend_error=0

		# Thanks Stephane
		code="set -- dummy"
		n="${#}"
		while [ "${n}" -gt 0 ]; do
			code="$code \"\${${n}}\""
			n="$((n - 1))"
		done
		eval "$code"

		while shift; [ "${#}" -gt 0 ]; do
			norm_path_to_add="${1}"

			test "${norm_path_to_add#*:}" = "${norm_path_to_add}" ||
				{ log.warn 'Cannot add path with colon'; path_prepend_error="1"; continue; }

			test -d "${norm_path_to_add}" ||
				{ log.warn "path_to_add ('${norm_path_to_add}') not a directory"; path_prepend_error="1"; continue; }

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
			norm_path="$(printf %s "${norm_path}" | sed "s/:$(printf %s "${norm_path_to_add}" | sed -f /proc/self/fd/3 3<&3)://g")" # remove all instances of PATH_TO_ADD from PATH
			exec 3<&-
			norm_path="$(printf %s "${norm_path}" | sed 's/:\+/:/g; s/^://; s/:$//')" # deduplicate colons, trim leading and trailing
			eval "${pathvar}=\$norm_path_to_add\${norm_path:+:\$norm_path}" # prepend with colon
		done
		return "${path_prepend_error}"
	} && export -f pathvarprepend

	pathvarappend () {
		# appending paths to pathvar denoted by the expansion of the PATHVAR parameter
		# if it's already in the PATH, move it to the end
		# POSIX compliant version

		test -n "${2}" ||
			{ log.info "Usage: pathappend PATHVAR PATH_TO_ADD [PATH_TO_ADD...]";
			log.info "Example: pathappend LD_LIBRARY_PATH '${HOME}/.local/lib' '/usr/local/lib'";
			return 2; }

		pathvar="${1}"

		case "${pathvar}" in (*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*|""|[0123456789]*) false;; esac ||
			{ log.err 'Expanded pathvar is not a valid name/variable identifier'; return 3; }

		if [ "${pathvar}" = "PATH" ]; then
			test "${-#*r}" = "${-}" ||
				{ log.err 'Restricted shell, cannot change PATH'; return 4; }
		fi

		path_append_error="0"

		while shift; [ "${#}" -gt "0" ]; do
			norm_path_to_add="${1}"

			test "${norm_path_to_add#*:}" = "${norm_path_to_add}" ||
				{ log.warn 'Cannot add path with colon'; path_append_error="1"; continue; }

			test -d "${norm_path_to_add}" ||
				{ log.warn "path_to_add ('${norm_path_to_add}') not a directory"; path_append_error="1"; continue; }

			norm_path="$(printf %s ":$(eval "printf %s "'"'"\$${pathvar}"'"'):" | head -n 1 | sed 's|/\+|/|g; s/\/$//; s/:/::/g')" # fence with colons, ensure one line, deduplicate slashes, trim trailing, duplicate colons
			norm_path_to_add="$(printf %s "${norm_path_to_add}" | head -n 1 | sed 's|/\+|/|g; s/\/$//')" # ensure one line, deduplicate slashes, trim trailing
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
			norm_path="$(printf %s "${norm_path}" | sed "s/:$(printf %s "${norm_path_to_add}" | sed -f /proc/self/fd/3 3<&3)://g")" # remove all instances of PATH_TO_ADD from PATH
			exec 3<&-
			norm_path="$(printf %s "${norm_path}" | sed 's/:\+/:/g; s/^://; s/:$//')" # deduplicate colons, trim leading and trailing
			eval "${pathvar}=\${norm_path:+\$norm_path:}\$norm_path_to_add" # append with colon
		done
		return "${path_append_error}"
	} && export -f pathvarappend

	path_append () {
		pathvarappend PATH "$@"
	} && export -f path_append

	ld_lib_path_append () {
		pathvarappend LD_LIBRARY_PATH "$@"
	} && export -f ld_lib_path_append

	cdpath_append () {
		pathvarappend CDPATH "$@"
	} && export -f cdpath_append

	path_prepend () {
		pathvarprepend PATH "$@"
	} && export -f path_prepend

	ld_lib_path_prepend () {
		pathvarprepend LD_LIBRARY_PATH "$@"
	} && export -f ld_lib_path_prepend

	cdpath_prepend () {
		pathvarprepend CDPATH "$@"
	} && export -f cdpath_prepend

	# ld_lib_path_append \
	# 	"${HOME}/.local/lib"

	set | grep -sq '^\(TMUX_PANE\|SSH_CONNECTION\)' && exec 2>/dev/null
	path_prepend \
		"/bin" \
		"/sbin" \
		"/usr/bin" \
		"/usr/sbin" \
		"/usr/local/bin" \
		"/usr/local/sbin" \
		"/usr/games" \
		"/usr/local/games" \
		"/snap/bin" \

	path_append \
		"${HOME}/bin" \
		"${HOME}/.bin" \
		"${HOME}/.local/bin" \
		"${HOME}/.local/sbin" \
		"${HOME}/.brew/bin" \
		"${GOPATH}/bin"
	set | grep -sq '^\(TMUX_PANE\|SSH_CONNECTION\)' && exec 2>/dev/tty


	# add cargo bin to path
	if [ -f "${HOME}/.cargo/env" ] && [ -r "${HOME}/.cargo/env" ]; then
		. "${HOME}/.cargo/env"
	fi

	export NVM_DIR="${HOME}/.nvm"
	[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"
	[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"

	if ! set | grep -sq '^\(TMUX_PANE\|SSH_CONNECTION\)' ; then
		pidof -q startx && 1>/home/tosuman/.startx.log 2>&1 startx || log.warn "Not starting X again"
	fi
	log.info ".profile sourced"
	export PROFILE_SOURCED='1'
fi

# if running bash
[ -n "${BASH_VERSINFO}" ] && [ -f "${HOME}/.bashrc" ] && [ -r "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
