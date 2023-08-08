#!/usr/bin/bash
# This file ought to be sourced, above line for syntax highlighting purposes.

######################## BASH RESET #############################
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
COMMANDS_="${COMMANDS_} PROMPT_COMMAND PS0 PS1 PS2 PS3 PS4"
# shellcheck disable=SC2086
2>/dev/null \unset -f -- ${COMMANDS_}
# shellcheck disable=SC2086
2>/dev/null \unalias -- ${COMMANDS_}
2>/dev/null \unset -- POSIXLY_CORRECT COMMANDS_
######################## BASH RESET END #############################

[ -z "${PS1}" ] && return
set -o emacs
shopt -s histappend
shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -u histverify
HISTSIZE=-1
HISTFILESIZE=-1
HISTFILE="${HOME}"/.bash_history
HISTTIMEFORMAT=$'\033[m%F %T: '
HISTCONTROL='ignoredups:erasedups:ignorespace'
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

alias v='nvim'
alias vim='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias sudo='sudo '
alias watch='watch '
alias tmux='tmux -2'
alias open='xdg-open'
alias xcopy='xsel --clipboard --input'
alias xpaste='xsel --clipboard --output'
alias aptclean='sudo apt -y update && sudo apt -y full-upgrade &&
                sudo apt -y dist-upgrade && sudo apt -y autoremove &&
                sudo apt -y clean'
alias paruuu='   yes | sudo pacman -Sy archlinux-keyring \
              && yes | sudo pacman -Syyuu --noconfirm \
              && yes | paru --devel --noconfirm'
alias pacman='pacman --color=auto'
alias pcker='nvim "${HOME}"/.config/nvim/lua/*/packer.lua'
alias after='nvim "${HOME}"/.config/nvim/after/plugin'
alias l='\ls --width="${COLUMNS}" --sort=time --time=mtime --color=auto --time-style=long-iso -bharZ1l'
# alias l='lsd --timesort --color=auto -harZ1l'
alias ll='\ls --width="${COLUMNS}" --sort=time --time=mtime --color=auto --fu -bharZ1l'
alias ls='\ls --width="${COLUMNS}" --color=auto -bC'
alias ip='ip --color=auto'
alias grep='grep --color=auto'
alias diff='diff --width="${COLUMNS}" --color=auto'
alias less='less -SR'
alias dmesg='dmesg --color=auto --reltime --human --nopager --decode'
alias free='free -mht'
alias tree='tree --dirsfirst -C'
alias francinette='"${HOME}"/francinette/tester.sh'
alias paco='"${HOME}"/francinette/tester.sh'
alias wttr='curl wttr.in'
alias s='sudo $(fc -nl -2 | head -1 | cut -c3-)' # cut -c2- for bash posix mode
alias colors='bash -c "$(curl --silent --location \
"https://gist.githubusercontent.com/HaleTom/\
89ffe32783f89f403bba96bd7bcd1263/raw"
)"'
alias sl='sl -GwFdcal'
alias cmatrix='cmatrix -u3 -Cred'
alias gca='git add -u && git commit -m "Automatic add"'
alias watch='watch -tcn.1'
alias pacop='clear && 2>/dev/null paco && 2>/dev/null paco --strict'
alias norm='alacritty -e sh -c '\''watch -cn.5 \
            norminette -R CheckForbiddenSourceHeader'\'' & disown'
alias norm2='alacritty -e sh -c '\''watch -cn.5 \
            norminette -R CheckForbiddenSourceHeader \| \
            xargs -I{} printf \"{} \#\#\# \"'\'' & disown'
alias dotconf='git --git-dir="${HOME}"/.dotfiles/ --work-tree="${HOME}"'
2>/dev/null dotconf config status.showUntrackedFiles no

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
	newst='3.3.53'
	if [ ! "${vers}" = "${newst}" ] ; then
		printf "%s\n%b\n" "Norminette v${vers} instead of v${newst} detected."\
                          '\033[31mPlease up-/downgrade\033[m'
	fi
	$(type -P norminette) -R CheckForbiddenSourceHeader "${@}"
}

function __norm () {
	local _pwd

	_pwd="$(pwd -P)"
	[ -z "${_pwd##"${HOME}"/42/42cursus/*}" ] || { return 1; }
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

	# shellcheck disable=SC2015
    git clone --quiet "${repo_url}" "${folder}" && {
        cd "${folder}";
		norminette -R CheckForbiddenSourceHeader ".";
	} || { printf '%s\n' "Could not clone repo!"; }
}

# shellcheck disable=SC2016
export GIT_SSH_COMMAND='ssh -oIdentitiesOnly=yes -F"${HOME}"/.ssh/config'
export TERM='xterm-256color'
# shellcheck disable=SC2155
export VISUAL="$(2>/dev/null command -v nvim)"
# shellcheck disable=SC2155
export EDITOR="$(2>/dev/null command -v vim  ||
                 2>/dev/null command -v vi   ||
                 2>/dev/null command -v nano ||
                 2>/dev/null command -v ed)"
export SUDO_EDITOR="${EDITOR}"
export GIT_PS1_SHOWDIRTYSTATE='1'
export MANPAGER='nvim +Man!'
[ -z "${DISPLAY}" ] && echo 'Warning: DISPLAY is not set'


###################### PROMPT STUFF #######################
# If bash runs in posix mode, if should be `cut -c2-` instead
# shellcheck disable=SC2016
PS0='$(clear -x ; printf "${PS1@P}" ; fc -nl -1 | cut -c3- ; printf "\n")'

GIT_PROMPT="1"
if [ ! -f "${HOME}"/git-prompt.sh ] && [ "${GIT_PROMPT}" = "1" ] ; then
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
[ -n "${_PS1_SSH}" ] && _PS1_HOST_CLR='\[\033[30;42m\]' || \
                        _PS1_HOST_CLR='\[\033[32m\]'
_PS1_1="${_PS1_USER}"
_PS1_1="${_PS1_1}@${_PS1_HOST_CLR}"
_PS1_1="${_PS1_1}\h\[\033[m\]"
_PS1_1="${_PS1_1}${_PS1_SSH}${_PS1_TMUX} "
_PS1_1="${_PS1_1}${_PS1_CWD_CLR}"
_PS1_1="${_PS1_1}[\w]"
# shellcheck disable=SC2016
_PS1_GIT='\[\033[m\]\[\033[36m\]$(__git_ps1 " (%s)")'
# shellcheck disable=SC2016
_PS1_2='\[\033[m\]\[\033[36m\]$(__norm)\[\033[m\]\n\[\033[35m\]~\$\[\033[m\] '

if [ -f "${HOME}"/git-prompt.sh ] && [ -r "${HOME}"/git-prompt.sh ] && \
                                     [ "${GIT_PROMPT}" = "1" ] ; then
	# shellcheck disable=SC1091
    . "${HOME}"/git-prompt.sh
    PS1="${_PS1_1}${_PS1_GIT}${_PS1_2}"
else
    PS1="${_PS1_1}${_PS1_2}"
fi
######################### PROMPT STUFF END #######################

# Key Repeat/Delay Rate
2>/dev/null xset r rate 200 60
# Disable bell
2>/dev/null xset -b
# sudo kbdrate --rate=30.0 --delay=250


# shellcheck disable=SC1091
if [ -f "${HOME}"/.userbashrc ]; then . "${HOME}"/.userbashrc; fi

# Simplified *Bash* Prompt, e.g. for tty/system/linux console
# unset PS0; PS1='\033[94m\u\033[37m@\033[32m\h\033[37m@\033[33m$(basename -- "$(tty)") \033[36m\w \033[35m\$\033[m '
