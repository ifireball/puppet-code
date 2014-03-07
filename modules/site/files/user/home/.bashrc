# .bashrc
# THIS FILE IS MANAGED BY PUPPET 
# DO NOT CHANGE MANUALLY
# Use .bashrc.custom to place your own settings

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# include .bashrc.custom if it exists
if [ -f ~/.bashrc.custom ]; then     
	. ~/.bashrc.custom
fi
