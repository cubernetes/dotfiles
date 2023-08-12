#!/usr/bin/bash
# This file ought to be sourced, above line for syntax highlighting purposes.

# shellcheck disable=SC2009
if ! ps aux|grep -v grep|grep startx 1>/dev/null; then
	startx 1>/home/tosuman/.startx.log 2>&1
fi

# if running bash
if [ -n "$BASH_VERSION" ] ; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ] && [ -r "$HOME/.bashrc" ]; then
		# shellcheck disable=SC1091
		. "$HOME/.bashrc"
	fi
fi
