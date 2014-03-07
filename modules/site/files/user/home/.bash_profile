# .bash_profile
# THIS FILE IS MANAGED BY PUPPET 
# DO NOT CHANGE MANUALLY
# Use .bash_profile.custom to place your own settings

# include .profile if it exists
if [ -f ~/.profile ]; then     
	. ~/.profile               
fi

# include .bash_profile.custom if it exists
if [ -f ~/.bash_profile.custom ]; then     
	. ~/.bash_profile.custom
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

