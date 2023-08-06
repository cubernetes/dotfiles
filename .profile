if ! ps aux|grep -v grep|grep startx 1>/dev/null; then
	startx 1>/home/tosuman/.startx.log 2>&1
fi

# if running bash
if [ -n "$BASH_VERSION" ] ; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ] && [ -r "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
