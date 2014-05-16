# Class: icinga::server
#
# Setup an Icinga monitoring server
#
class icinga::server {
  include icinga::repo
  Package { require => Class['icinga::repo'], }
  #package { [ 'icinga', 'icinga-doc' ]: }
}

