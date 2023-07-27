#!/usr/bin/bash
# This file ought to be sourced

# Bash Shell Reset -- Start
IFS=" 
	"
POSIXLY_CORRECT='1'
COMMANDS_="builtin unalias unset read printf command exit type . tr fc compgen"
COMMANDS_="${COMMANDS_} wc sed grep xargs sudo shopt kill ps head awk clear"
COMMANDS_="${COMMANDS_} curl wget source check mv mkdir rm rmdir while do done"
COMMANDS_="${COMMANDS_} cc gcc g++ clang basename clone42 git alias export pwd"
COMMANDS_="${COMMANDS_} docker shift until for in bash sh dash ash ksh zsh top"
COMMANDS_="${COMMANDS_} shellcheck watch cmatrix alacritty tmux zellij ssh"
COMMANDS_="${COMMANDS_} which date df du case esac crontab ping base64 apt"
COMMANDS_="${COMMANDS_} paru pacman yum dnf aptitude apt-get yay rpm dpkg env"
COMMANDS_="${COMMANDS_} awk apropos help info dirname bc dc break continue"
COMMANDS_="${COMMANDS_} unzip zip tar untar gzip gunzip xz unxz base32 cal"
COMMANDS_="${COMMANDS_} chattr cfdisk fdisk passwd chroot cmp cron split dd"
COMMANDS_="${COMMANDS_} df dir declare diff dircolors dmesg eval exec egrep"
COMMANDS_="${COMMANDS_} false true : fg bg free fold find file gawk groupadd"
COMMANDS_="${COMMANDS_} less more cat head tail chmod chown history sleep yes"
COMMANDS_="${COMMANDS_} useradd adduser addgroup usermod groupdel userdel xxd"
COMMANDS_="${COMMANDS_} groups users who w last hash hostname htop ip ifconfig"
COMMANDS_="${COMMANDS_} install ifdown ifup jobs killall pkill pgrep klist"
COMMANDS_="${COMMANDS_} link ln unlink let local logout logname lsblk lsof"
COMMANDS_="${COMMANDS_} pidof lspci lsusb lscpu make mktemp mount umount nc"
COMMANDS_="${COMMANDS_} ncat nmap nft iptables ufw firewall-cmd nl nslookup"
COMMANDS_="${COMMANDS_} open xdg-open whereis whatis write wall agetty amixer"
COMMANDS_="${COMMANDS_} pulsemixer ar cmake bzip2 ccrypt chvt column chsh ex"
COMMANDS_="${COMMANDS_} od pushd popd pv pvs lvs vgs rsync screen sed seq wait"
COMMANDS_="${COMMANDS_} ftp sftp shift shuf sort uniq su strace sync tee test"
COMMANDS_="${COMMANDS_} time trap tr tty ulimit umask unix2dos dos2unix uptime"
COMMANDS_="${COMMANDS_} paco francinette cd ls disown whoami reboot systemctl"
COMMANDS_="${COMMANDS_} shutdown poweroff set x touch stat cp scp man locate"
COMMANDS_="${COMMANDS_} xset kbdrate return cut batcat id ed vi vim nvim nano"
COMMANDS_="${COMMANDS_} skill norminette bat echo if then fi else function"
# shellcheck disable=SC2086
2>/dev/null \unset -f -- ${COMMANDS_}
# shellcheck disable=SC2086
2>/dev/null \unalias -- ${COMMANDS_}
2>/dev/null \unset -- POSIXLY_CORRECT COMMANDS_
# Bash Shell Reset -- End

[ -z "${PS1}" ] && return
shopt -s histappend
shopt -s checkwinsize
shopt -s dotglob
HISTSIZE=-1
HISTFILESIZE=-1
HISTFILE="${HOME}"/.bash_history
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

function skill () {
	if [ -n "${1}" ] ; then
		# shellcheck disable=SC2046,SC2009
		2>/dev/null sudo kill -9 \
			$(ps aux | grep "${1}" | head -1 | awk '{print $2}')
	else
		echo 'Please provide one argument'
	fi
}

function bat () {
	2>/dev/null batcat "${@}" || \
		1>/dev/null type -P bat && \
		$(type -P bat) "${@}" || \
		{ echo "bat not installed"; return 1; }
}

function norminette () {
	local vers="$($(type -P norminette) -v | cut -d" " -f2)"
	local newst='3.3.53'
	if [ ! "${vers}" = "${newst}" ] ; then
		printf "%s\n%b\n" "Norminette v${vers} instead of v${newst} detected."\
                          '\033[31mPlease up-/downgrade\033[m'
	fi
	$(type -P norminette) -R CheckForbiddenSourceHeader "${@}"
}

function __norm () {
	local _pwd="$(pwd -P)"
	[ -z "${_pwd##${HOME}/42/42cursus/*}" ] || { return 1; }
	1>/dev/null 2>&1 git status || { return 2; }
    1>/dev/null 2>&1 norminette && printf ' \033[92m%s\033[m' "[Norm: OK]" || printf ' \033[101;37m%s\033[m' "[䝝誒 ‼ NORM ‼ 屌誒]"
    return 0
}

function ft_check () {
    # Set params
    URL="${1}"
    DIR="/tmp/tmp_repo_$(date +%s)"

    # If no URL, get it from current repo
    if [ -z "${URL}" ] ; then
        URL="$(git remote get-url origin)"
    fi

    # Clone in temp folder
    git clone --quiet "${URL}" "${DIR}"

    # Only proceed if clone success
    if [ -d "${DIR}" ] ; then
        # Check the norm and print beautiful message
        norminette -R CheckForbiddenSourceHeader "${DIR}" && printf '\033[30;102m%s\033[m\n' "Norminette success" || printf '\033[30;101m%s\033[m\n' "Norminette fail!!!"

            # Remove temp folder
            rm -rf "${DIR}"
        else
            printf '\033[30;101m%s\033[m\n' "Could not clone the repo"
    fi
}

function clone42 () {
    folder="${1}"
    repo_url="${2}"

    git clone --quiet "${repo_url}" ${folder}
    if [ "${?}" = "0" ]; then
        cd "${folder}"
		norminette -R CheckForbiddenSourceHeader "."
    else
        printf '%s\n' "Could not clone repo!"
    fi
}

alias v=nvim
alias vim=nvim
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias tmux='tmux -2'
alias open='xdg-open'
alias xcopy='xsel --clipboard --input'
alias xpaste='xsel --clipboard --output'
alias aptclean='sudo apt -y update && sudo apt -y full-upgrade &&
                sudo apt -y dist-upgrade && sudo apt -y autoremove &&
                sudo apt -y clean'
alias paruuu='yes | sudo pacman -Sy archlinux-keyring &&
              yes | sudo pacman -Syyuu && yes | paru'
alias pcker='nvim "${HOME}"/.config/nvim/lua/*/packer.lua'
alias after='nvim "${HOME}"/.config/nvim/after/plugin'
alias l='ls --color=auto -FhalrtZ1'
alias ls='ls --color=auto'
alias ll='ls --color=auto -FhalrtZ1'
alias grep='grep --color=auto'
alias francinette='"${HOME}"/francinette/tester.sh'
alias paco='"${HOME}"/francinette/tester.sh'
alias p='pulsemixer'
alias e='nvim "${HOME}"/repos/dwm/config.h'
alias colors='bash -c "$(curl --silent --location \
"https://gist.githubusercontent.com/HaleTom/\
89ffe32783f89f403bba96bd7bcd1263/raw"
)"'
alias sl='sl -GwFdcal'
alias cmatrix='cmatrix -u3 -Cred'
alias gca='git add -u && git commit -m "Automatic add"'
alias watch='watch -tcn.1'
alias norm='alacritty -e sh -c '\''watch -cn.5 \
            norminette -R CheckForbiddenSourceHeader'\'' & disown'
alias norm2='alacritty -e sh -c '\''watch -cn.5 \
            norminette -R CheckForbiddenSourceHeader \| \
            xargs -I{} printf \"{} \#\#\# \"'\'' & disown'
alias dotconf='git --git-dir="${HOME}"/.dotfiles/ --work-tree="${HOME}"'
2>/dev/null dotconf config status.showUntrackedFiles no

PATH="${PATH}:${HOME}/.local/bin"

export USER42='tischmid'
export EMAIL42='timo42@proton.me'
export MAIL='timo42@proton.me'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export TERM='xterm-256color'
# shellcheck disable=SC2155
export XDG_RUNTIME_DIR=/run/user/"$(id -u)"
# shellcheck disable=SC2155
export SSH_AUTH_SOCK=/run/user/"$(id -u)"/ssh-agent.socket
# shellcheck disable=SC2155
export VISUAL="$(2>/dev/null command -v nvim)"
# shellcheck disable=SC2155
export EDITOR="$(2>/dev/null command -v vim  ||
                 2>/dev/null command -v vi   ||
                 2>/dev/null command -v nano ||
                 2>/dev/null command -v ed)"
export SUDO_EDITOR="${EDITOR}"
export GIT_PS1_SHOWDIRTYSTATE='1'
export PATH

2>/dev/null xset r rate 200 60
# sudo kbdrate --rate=30.0 --delay=250

GIT_PROMPT="1"
if [ ! -f "${HOME}"/git-prompt.sh ] && [ "${GIT_PROMPT}" = "1" ] ; then
	curl --silent --location \
"https://raw.githubusercontent.com/git\
/git/master/contrib/completion/git-prompt.sh" \
	-o "${HOME}"/git-prompt.sh
fi

# If bash runs in posix mode, if should be `cut -c2-` instead
PS0='$(clear -x ; printf "${PS1@P}" ; fc -nl -1 | cut -c3- ; printf "\n")'

_PS1_HOST_CLR='\033[32m'
_PS1_1='\[\033[31m\]\u\[\033[m\]@\['"${_PS1_HOST_CLR}"'\]\h\[\033[m\] \[\033[33m\][\w]'
_PS1_GIT='\[\033[m\]\[\033[36m\]$(__git_ps1 " (%s)")'
_PS1_2='\[\033[m\]\[\033[36m\]$(__norm)\[\033[m\]\n\[\033[35m\]~\$\[\033[m\] '

if [ -f "${HOME}"/git-prompt.sh ] && [ -r "${HOME}"/git-prompt.sh ] && \
                                     [ "${GIT_PROMPT}" = "1" ] ; then
    . "${HOME}"/git-prompt.sh
    PS1="${_PS1_1}${_PS1_GIT}${_PS1_2}"
else
    PS1="${_PS1_1}${_PS1_2}"
fi

