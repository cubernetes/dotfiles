# if running bash
if [ -n "$BASH_VERSION" ] ; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ] && [ -r "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

pathadd () {
	# just works
    NORM_PATH=":${PATH}:"
    NORM_PATH="$(printf '%s' "${NORM_PATH}" | sed 's/::/:/g')"
	# TODO: Handle Slashes
    NORM_PATH_TO_ADD=":${1}:"
    NORM_PATH_TO_ADD="$(printf '%s' "${NORM_PATH_TO_ADD}" | sed 's/::/:/g' | sed 's/::/:/g')"
    if [ "$(printf '%s' "${-}" | sed 's/r//')" = "${-}" ] && [ -d "${1}" ] && [ "$(printf '%s' "${NORM_PATH}" | sed "s/$(printf '%s' "${NORM_PATH_TO_ADD}" | awk '{gsub("\x2f", "\x5c\x2f"); print $0}')//")" = "${NORM_PATH}" ]; then
        PATH="${PATH:+"${PATH%:}"}${NORM_PATH_TO_ADD%:}"
    fi
}
export -f pathadd

ld_lib_path_add () {
	# just works
    NORM_PATH=":${PATH}:"
    NORM_PATH="$(printf '%s' "${NORM_PATH}" | sed 's/::/:/g')"
	# TODO: Handle Slashes
    NORM_PATH_TO_ADD=":${1}:"
    NORM_PATH_TO_ADD="$(printf '%s' "${NORM_PATH_TO_ADD}" | sed 's/::/:/g' | sed 's/::/:/g')"
    if [ "$(printf '%s' "${-}" | sed 's/r//')" = "${-}" ] && [ -d "${1}" ] && [ "$(printf '%s' "${NORM_PATH}" | sed "s/$(printf '%s' "${NORM_PATH_TO_ADD}" | awk '{gsub("\x2f", "\x5c\x2f"); print $0}')//")" = "${NORM_PATH}" ]; then
        PATH="${PATH:+"${PATH%:}"}${NORM_PATH_TO_ADD%:}"
    fi
}
export -f ld_lib_path_add

# shellcheck disable=SC2155
export XDG_RUNTIME_DIR=/run/user/"$(id -u)"
# shellcheck disable=SC2155
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/$(id -u)"/ssh-agent.socket

export USER42='tischmid'
export EMAIL42='timo42@proton.me'
export MAIL='timo42@proton.me'

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

export GOPATH="${HOME}"/go

ld_lib_path_add "${LD_LIBRARY_PATH}:${HOME}/.local/lib"
export LD_LIBRARY_PATH

pathadd '/bin'
pathadd '/sbin'
pathadd '/usr/bin'
pathadd '/usr/sbin'
pathadd '/usr/local/bin'
pathadd '/usr/lcoal/sbin'
pathadd '/usr/local/games'
pathadd '/usr/games'
pathadd '/snap/bin'
pathadd "${HOME}"/bin
pathadd "${HOME}"/.local/bin
pathadd "${HOME}"/.local/include
pathadd "${HOME}"/.brew/bin
pathadd "${GOPATH}"/bin
export PATH

# add cargo bin to path
if [ -f "${HOME}"/.cargo/env ] || [ -r "${HOME}"/.cargo/env ]; then
	. "${HOME}"/.cargo/env
fi

export NVM_DIR="${HOME}"/.nvm
# shellcheck disable=SC1091
[ -s "${NVM_DIR}"/nvm.sh ] && . "${NVM_DIR}"/nvm.sh
# shellcheck disable=SC1091
[ -s "${NVM_DIR}"/bash_completion ] && . "${NVM_DIR}"/bash_completion



if ! ps aux|grep -v grep|grep startx 1>/dev/null; then
	2>/dev/null startx
fi
