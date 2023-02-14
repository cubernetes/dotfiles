#!/bin/sh

[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
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

skill() {
    if [ -n "${1}" ]; then
        sudo kill -9 $(ps aux | grep "${1}" | head -n -1 | awk '{print $2}') 2>/dev/null
    else
        echo "Please provide an argument"
    fi
}

bat() {
  batcat $1 || $(type -P bat) $1
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

alias dotconf='$(type -P git) --git-dir="${HOME}/.dotfiles/" --work-tree="${HOME}"'
dotconf config status.showUntrackedFiles no

##-----------------------------------------------------
## synth-shell-greeter.sh
if [ -f ~/.config/synth-shell/synth-shell-greeter.sh ] && [ -n "$( echo $- | grep i )" ]; then
  :
	#. ~/.config/synth-shell/synth-shell-greeter.sh
fi

##-----------------------------------------------------
## synth-shell-prompt.sh
if [ -f ~/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
	. ~/.config/synth-shell/synth-shell-prompt.sh
fi

##-----------------------------------------------------
## better-ls
if [ -f ~/.config/synth-shell/better-ls.sh ] && [ -n "$( echo $- | grep i )" ]; then
	. ~/.config/synth-shell/better-ls.sh
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
