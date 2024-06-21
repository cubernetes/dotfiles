#! /bin/bash --
# ex: set ts=4 sw=4 ft=sh

# shellcheck disable=SC2009
1>/dev/null pidof -q startx && 1>/home/tosuman/.startx.log 2>&1 startx

# if running bash
[ -n "$BASH_VERSINFO" ] && if [ -f "$HOME/.bashrc" ] && [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
