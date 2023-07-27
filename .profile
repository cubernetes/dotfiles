# if running bash
if [ -n "$BASH_VERSION" ] ; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ] && [ -r "$HOME/.bashrc" ] ; then
		. "$HOME/.bashrc"
	fi
	fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

# add cargo bin to path
if [ -f "${HOME}"/.cargo/env ] || [ -r "${HOME}"/.cargo/env ]; then
	. "${HOME}"/.cargo/env
fi

if ! ps aux|grep -v grep|grep startx 1>/dev/null; then
	2>/dev/null startx
fi
