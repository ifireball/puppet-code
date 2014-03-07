# zzz_site_bashrc
# Site-wide .bashrc file
# (mostly stuff copied from Debian default bashrc)
#
# THIS FILE IS MANAGED BY PUPPET 
# DO NOT CHANGE MANUALLY

_site_bashrc() {
	# If not in bash, don't do anything
	[ -z "$BASH_VERSION" ] && return
	# If not running interactively, don't do anything
	[ -z "$PS1" ] && return

	# don't put duplicate lines in the history. See bash(1) for more options
	export HISTCONTROL=ignoredups

	# check the window size after each command and, if necessary,
	# update the values of LINES and COLUMNS.
	shopt -s checkwinsize

	# make less more friendly for non-text input files, see lesspipe(1)
	[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

	# setup colorful and spacy prompt
	PS1='
\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]
\$ '

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*)
			PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:
			${PWD/$HOME/~}\007"'
			;;
		*)
			;;
	esac

	# enable color support of various utilities
	if [ "$TERM" != "dumb" ]; then
		eval "`dircolors -b`"
		alias ls='ls --color=auto'
		alias egrep='egrep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias grep='grep --color=auto'
	fi

	# some more ls aliases
	alias ll='ls -l'
	alias la='ls -A'
	alias l='ls -CF'
}

# Run settings only for interactive shells
_site_bashrc

unset _site_bashrc

