#!/bin/sh

export PATH="${PATH}:/home/tosuman/.local/bin"
export SHELL='/usr/bin/bash'
export DISPLAY=:0

number_of_tmux_sessions="$(tmux ls | wc -l)"

if [ "${number_of_tmux_sessions}" = "0" ] ; then
	alacritty & disown
	sleep 1
fi

tmux new-window -c '/home/tosuman' \
	&& tmux rename-window 'System Update' \
	&& tmux send-key 'paruuu' ENTER
