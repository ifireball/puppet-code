# .profile
# THIS FILE IS MANAGED BY PUPPET 
# DO NOT CHANGE MANUALLY
# Use .profile.custom to place your own settings

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

# include .profile.custom if it exists
if [ -f ~/.profile.custom ]; then     
	. ~/.profile.custom
fi
