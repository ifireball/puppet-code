# Class site::sudo
#
# Site sudo configuration
#
class site::sudo {
  class { 'sudo': }
  sudo::conf { 'defaults':
    priority => 1,
    content => '
Defaults    requiretty

Defaults    env_reset
Defaults    env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"
Defaults    env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults    env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults    env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"
Defaults    env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"
Defaults    env_keep += "SSH_AUTH_SOCK"

Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
',
  }
  sudo::conf { 'wheel':
    priority => 5,
    content => '
## Allow root to run any commands anywhere 
root    ALL=(ALL)       ALL

## Unify the various names different OSes have for 
## "the group that can run anything"
User_Alias WHEEL = %wheel, %sudo

## Allows people in group wheel to run all commands
WHEEL   ALL=(ALL)       ALL
',
  }
  sudo::conf { 'wheel_nopasswd':
    content => $osfamily ? {
      'RedHat' => '
WHEEL   ALL=(root)      NOPASSWD: /usr/bin/yum check-update,\
                        /usr/bin/yum update, /usr/bin/yum upgrade,\
                        /usr/bin/yum list *, /usr/bin/yum search *
',
      'Debian' => '
WHEEL   ALL=(root)      NOPASSWD: /usr/bin/aptitude update,\
                        /usr/bin/aptitude upgrade,\
                        /usr/bin/aptitude full-upgrade
'
  }
}

